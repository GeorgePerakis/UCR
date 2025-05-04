extends Node3D

@export var enemy_scene: PackedScene = preload("res://Entities/Enemy/Enemy.tscn")
@onready var shared_path: Path3D = $Path3D
var place = 5

func _ready() -> void:
	$Timer.start()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	
	enemy.path = shared_path
	
	add_child(enemy)
	enemy.global_position = Vector3(place,3,0)
	place += 5


func _on_timer_timeout() -> void:
	spawn_enemy()
