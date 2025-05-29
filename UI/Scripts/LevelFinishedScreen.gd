extends Control

@onready var quit_button: Button = $"VBoxContainer/Main Buttons/HBoxContainer/Quit Button"
@onready var next_level: Button = $"VBoxContainer/Main Buttons/HBoxContainer/Next Level"
@onready var enemies_killed: RichTextLabel = $"VBoxContainer/Main Buttons/Enemies Killed"
@onready var enemies_spawned: RichTextLabel = $"VBoxContainer/Main Buttons/Enemies Spawned"

func _ready():
	quit_button.pressed.connect(_on_quit_pressed)
	next_level.pressed.connect(_on_next_level_pressed)
	self.visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		enemies_killed.append_text(str(GameManager.enemy_deaths))
		enemies_spawned.append_text(str(GameManager.enemy_spawns))

func _on_quit_pressed():
	get_tree().paused = false
	GameManager.enemy_deaths = 0
	GameManager.enemy_spawns = 0
	GameManager.current_enemy_ammount = 0
	get_tree().change_scene_to_file("res://UI/Scenes/MainScreen.tscn")

func _on_next_level_pressed():
	get_tree().paused = false
	GameManager.enemy_deaths = 0
	GameManager.enemy_spawns = 0
	GameManager.current_enemy_ammount = 0
	get_tree().change_scene_to_file("res://Levels/Level2/Level.tscn")
