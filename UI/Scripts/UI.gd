extends Control

@onready var number_of_drones_killed: RichTextLabel = $"HBoxContainer/MarginContainer/Number of Drones Killed"
@onready var label: RichTextLabel = $HBoxContainer/RichTextLabel
@onready var level_finished_screen: Control = $"../LevelFinishedScreen"

var time_left: float = 60
var countdown_active: bool = true


func _ready():
	GameManager.enemy_died.connect(_on_enemy_died)
	
func _process(delta: float) -> void:
	if countdown_active:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			countdown_active = false
			_on_countdown_finished()
		
		update_label()

func _on_enemy_died():
	number_of_drones_killed.text = str(GameManager.enemy_deaths)

func update_label():
	if label:
		label.text = " %.2f" % time_left

func _on_countdown_finished():
	visible = false
	level_finished_screen.visible = true
	get_tree().paused = true
