extends Node3D

@export var enemy_scene = preload("res://Entities/Enemy/Enemy.tscn")
@export var camera_node: Node
@onready var path = $Path3D
@onready var timer: Timer = $Timer
var player

func _ready():
	flatten_path_y(1.5)
	timer.start()
		
func _process(delta: float) -> void:
	if GameManager.current_enemy_ammount < 3 and timer.is_stopped():
		timer.start()
	elif GameManager.current_enemy_ammount >= 3 and !timer.is_stopped():
		timer.stop()
	
func spawn_enemy():
	var players = get_tree().get_nodes_in_group("Player")
	if players.is_empty():
		return

	var player = players[0]
	var path_length = path.curve.get_baked_length()
	var player_offset = path.curve.get_closest_offset(player.global_position)

	const MAX_ATTEMPTS = 10
	const OFFSET_INCREMENT = 10.0
	const MIN_DISTANCE = 10.0
	
	for i in range(MAX_ATTEMPTS):
		var spawn_offset = clamp(player_offset + 20.0 + i * OFFSET_INCREMENT, 0, path_length)
		var spawn_position = path.curve.sample_baked(spawn_offset)

		if is_position_free(spawn_position, MIN_DISTANCE):
			var enemy = enemy_scene.instantiate()
			enemy.path = path
			add_child(enemy)
			enemy.global_position = spawn_position
			
			await get_tree().process_frame
			var forward_dir = enemy.path_follow.transform.basis.z.normalized()
			enemy.look_at(enemy.global_transform.origin + forward_dir, Vector3.UP)
			enemy.get_child(0).linear_velocity = -forward_dir * 10
			return  


func flatten_path_y(y_value: float):
	var curve = path.curve
	for i in curve.get_point_count():
		var point = curve.get_point_position(i)
		point.y = y_value
		curve.set_point_position(i, point)

func is_position_free(pos: Vector3, min_distance: float) -> bool:
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.global_position.distance_to(pos) < min_distance:
			return false
	return true


func _on_timer_timeout():
	spawn_enemy()
