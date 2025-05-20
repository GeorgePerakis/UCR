extends Node3D
@onready var Car := $Car as Node
@onready var Explosion: Node3D = $Car/Explosion
@onready var Fire: GPUParticles3D = $Car /Fire
@onready var progress_marker = $ProgressMarker
@onready var mesh_parts := [$Car/Chasis, $Car/Wheels/FR/Wheel, $Car/Wheels/FL/Wheel, $Car/Wheels/BR/Wheel, $Car/Wheels/BL/Wheel]

var player
var target
var is_dead = false
var health = 100.0

var turn_threshold = 0.13
var drift_threshold = 0.5

var path
var path_follow
var speed = 20

func _ready():
	init_enemy_scene()

func _process(delta: float) -> void:
	path_follow.progress += delta * speed
	
	var progress_position = path.curve.sample_baked(path_follow.progress)
	progress_marker.global_position = progress_position
	
	update_ai_behavior()

func update_ai_behavior():
	chase_target(path_follow.global_position)
	
	#var distance = Car.global_position.distance_to(target_position)
	#var stopping_distance = 20.0 

	Car.AccelerationInstance.is_accelerating = true
	#Car.AccelerationInstance.is_braking = distance <= stopping_distance

func chase_target(target):
	var direction_to_target = (target - Car.global_position).normalized()
	var forward = Car.global_transform.basis.z.normalized()
	
	var angle_to_target = forward.angle_to(direction_to_target)
	var cross = forward.cross(direction_to_target).y
	
	if angle_to_target > turn_threshold:
		Car.SteeringInstance.turn_left = cross > 0
		Car.SteeringInstance.turn_right = cross < 0
		if angle_to_target > drift_threshold:
			Car.SteeringInstance.is_drifting = true
		else:
			Car.SteeringInstance.is_drifting = false
	else:
		Car.SteeringInstance.turn_left = false
		Car.SteeringInstance.turn_right = false
	
func die():
	GameManager.emit_signal("enemy_died")
	GameManager.current_enemy_ammount -= 1
	
	is_dead = true
	
	Car.set_center_of_mass(Vector3(0, 0, 0))
	var upward_force = Vector3.UP * 27000 
	Car.apply_impulse(Vector3.ZERO, upward_force)
	
	var random_torque = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-0.5, 0.5),
		randf_range(-1.0, 1.0)
	).normalized() * 24000  
	Car.apply_torque_impulse(random_torque)
	
	Explosion.explode()
	
	await get_tree().create_timer(3).timeout
	queue_free()
	
func init_enemy_scene():
	GameManager.emit_signal("enemy_spawned")
	GameManager.current_enemy_ammount += 1
	GameManager.enemy_spawns += 1
	
	for part in mesh_parts:
		fade_mesh(part, 0.2)
		
	await get_tree().process_frame
	
	path_follow = PathFollow3D.new()
	path.add_child(path_follow)
	
	var offset = path.curve.get_closest_offset(global_position)
	
	var spawn_offset = offset + 5
	var path_length = path.curve.get_baked_length()

	spawn_offset = clamp(spawn_offset, 0, path_length)
	
	path_follow.progress = spawn_offset
	
func inflict_damage():
	health -= 10
	if health <= 40:
		Fire.emitting = true
	if health == 0:
		die()

func fade_mesh(mesh, duration):
	var tween = create_tween()
	for i in mesh.mesh.get_surface_count():
		var material = mesh.get_surface_override_material(i)

		if material == null:
			material = mesh.mesh.surface_get_material(i)
			if material != null:
				material = material.duplicate()
				mesh.set_surface_override_material(i, material)

		if material is StandardMaterial3D:
			material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			material.flags_transparent = true

			var color = material.albedo_color
			color.a = 0.0
			material.albedo_color = color

			tween.tween_property(material, "albedo_color:a", 1.0, duration)
			
			tween.tween_callback(func():
				material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
				material.flags_transparent = false
			)
			

#func _on_car_body_entered(body: Node) -> void:
	#if body.is_in_group("Enemy") and body != self and is_dead:
		#body.get_parent().die()
