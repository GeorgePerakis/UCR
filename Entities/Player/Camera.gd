extends Camera3D

@export var target: Node3D
var duration := 0.2
var magnitude := 0.2

var follow_offset := Vector3(0, 2, -3)
var follow_speed := 5.0

var look_at_target := true
var look_ahead_distance := 2.0
var max_distance := 3.0

var min_fov := 70
var max_fov := 100
var fov_speed_sensitivity := 0.5

var shake_offset := Vector3.ZERO
var is_shaking := false

func _ready():
	SignalBus.connect("enemy_died", Callable(self, "_on_enemy_died"))

func _physics_process(delta: float) -> void:
	if target:
		smooth_follow(delta)
		update_dynamic_fov(delta)

func _on_enemy_died():
	screen_shake()

func screen_shake():
	if is_shaking:
		return

	is_shaking = true
	var elapsed_time := 0.0

	while elapsed_time < duration:
		var decay := 1.0 - (elapsed_time / duration)
		shake_offset = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			0
		) * magnitude * decay

		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	shake_offset = Vector3.ZERO
	is_shaking = false

func smooth_follow(delta):
	var desired_position = target.global_transform.origin \
		+ target.global_transform.basis.z * follow_offset.z \
		+ target.global_transform.basis.y * follow_offset.y \
		+ target.global_transform.basis.x * follow_offset.x

	if global_position.distance_to(target.global_position) > max_distance:
		global_position = target.global_position \
			+ (global_position - target.global_position).normalized() * max_distance

	global_position = global_position.lerp(desired_position, delta * follow_speed)

	global_position += shake_offset

	if look_at_target:
		var look_point = target.global_transform.origin \
			+ target.global_transform.basis.z * look_ahead_distance
		look_at(look_point, Vector3.UP)
		
func update_dynamic_fov(delta: float):
	if !target.has_method("get_linear_velocity"):
		return
	
	var velocity: Vector3 = target.get_linear_velocity()
	var speed = velocity.length()
	
	var target_fov = clamp(min_fov + speed * fov_speed_sensitivity, min_fov, max_fov)
	fov = lerp(fov, target_fov, delta * 5.0)
