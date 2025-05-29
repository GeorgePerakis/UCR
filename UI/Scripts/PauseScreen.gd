extends Control
@onready var resume_button: Button = $"Main Buttons/Resume Button"
@onready var options_button: Button = $"Main Buttons/Options Button"
@onready var quit_button: Button = $"Main Buttons/Quit Button"
@onready var back_button: Button = $Options/Back
@onready var volume_slider: HSlider = $Options/Volume
@onready var main_buttons: VBoxContainer = $"Main Buttons"
@onready var options: VBoxContainer = $Options

@onready var Car := get_node("../../Car")
@onready var machine_guns: Node3D = get_node("../../Car/Machine_Guns")

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	volume_slider.value_changed.connect(_on_volume_changed)
	
	back_button.pressed.connect(_on_back_pressed)
	
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

func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	
	Car.SteeringInstance.is_drifting = false
	Car.AccelerationInstance.is_accelerating = false
	Car.AccelerationInstance.is_braking = false
	machine_guns.shooting = false
	machine_guns.particles[0].emitting = false
	machine_guns.particles[1].emitting = false
