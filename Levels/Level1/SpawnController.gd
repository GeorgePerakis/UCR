extends Node3D

@export var enemy_scene = preload("res://Entities/Enemy/Enemy.tscn")
@export var camera_node: Node
@onready var shared_path = $Path3D
var place = 5
var player

func _ready():
	$Timer.start()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()

func spawn_enemy():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	var enemy = enemy_scene.instantiate()
	enemy.path = shared_path
	
	add_child(enemy)
	enemy.global_position = Vector3(place,3,0)
	place += 5
	
	GameManager.emit_signal("enemy_spawned")

func _on_timer_timeout():
	spawn_enemy()
