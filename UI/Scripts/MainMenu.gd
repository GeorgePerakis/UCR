extends Control
@onready var play_button: Button = $"Main Buttons/Play Button"
@onready var options_button: Button = $"Main Buttons/Options Button"
@onready var quit_button: Button = $"Main Buttons/Quit Button"
@onready var back_button: Button = $Options/Back
@onready var volume_slider: HSlider = $Options/Volume
@onready var main_buttons: VBoxContainer = $"Main Buttons"
@onready var options: VBoxContainer = $Options

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	volume_slider.value_changed.connect(_on_volume_changed)
	
	back_button.pressed.connect(_on_back_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Levels/Level1/Level1.tscn")
	
func _on_options_pressed():
	main_buttons.visible = false
	options.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	main_buttons.visible = true
	options.visible = false

func _on_volume_changed(value: float) -> void:
	_set_master_volume(value)
	ProjectSettings.set_setting("audio/master_volume", value)
	
func _set_master_volume(value: float) -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, value)
