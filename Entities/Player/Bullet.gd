extends Node3D

@onready var raycast = $RayCast3D
@onready var mesh = $MeshInstance3D
@onready var particles = $GPUParticles3D
@onready var audio = $AudioStreamPlayer3D

signal bullet_hit(target)

var speed = 120
var has_hit = false
var damage = 10

func _physics_process(delta: float) -> void:
	if has_hit:
		return
	
	var direction = transform.basis.z.normalized()
	var distance = speed * delta
	var from = global_transform.origin
	var to = from + direction * distance

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result:
		var hit_object = result.get("collider")
		if hit_object:
			emit_signal("bullet_hit", hit_object)
		
		has_hit = true
		mesh.visible = false
		particles.emitting = true
		audio.play()
		await get_tree().create_timer(1).timeout
		queue_free()
	else:
		global_position += direction * distance


func _on_timer_timeout() -> void:
	queue_free()
