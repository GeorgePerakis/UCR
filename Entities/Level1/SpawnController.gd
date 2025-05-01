extends Node3D

@export var enemy_scene: PackedScene = preload("res://Entities/Enemy/Enemy.tscn")
@onready var shared_path: Path3D = $Path3D

func _ready() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	
	enemy.path = shared_path
	
	add_child(enemy)
	enemy.global_position = Vector3(0,3,0)
