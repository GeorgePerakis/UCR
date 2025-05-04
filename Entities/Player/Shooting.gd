extends Node3D

@onready var guns = [$Gun1, $Gun2]
@onready var particles = [$Gun1/GPUParticles3D,$Gun2/GPUParticles3D]

var bullet = load("res://Entities/Player/Bullet.tscn")
var bullet_instance
var gun_index = 0
var shooting = false

func _input(event):
	if event.is_action_pressed("Shoot") and !shooting:
		shooting = true
		particles[0].emitting = true
		particles[1].emitting = true
		start_shooting()
	elif event.is_action_released("Shoot"):
		shooting = false
		particles[0].emitting = false
		particles[1].emitting = false

func start_shooting():
	while shooting:
		var current_gun = guns[gun_index]
		
		var anim_player = current_gun.get_node("AnimationPlayer")
		anim_player.play("Shoot")
		
		bullet_instance = bullet.instantiate()
		bullet_instance.connect("bullet_hit", Callable(self, "target_hit"))
		bullet_instance.position = current_gun.get_node("RayCast3D").global_position
		bullet_instance.transform.basis = get_parent().global_transform.basis
		
		get_parent().get_parent().get_parent().add_child(bullet_instance)
		
		await anim_player.animation_finished
		
		gun_index = (gun_index + 1) % guns.size()
		await get_tree().create_timer(0.1)

func target_hit(target):
	while target and !target.has_method("inflict_damage"):
		target = target.get_parent()

	if target:
		target.inflict_damage()
