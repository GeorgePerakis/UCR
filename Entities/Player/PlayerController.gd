extends Node3D
@onready var Car := $Car as Node

func _ready():
	await get_tree().process_frame

func _process(delta: float) -> void:
	Accept_Input()
	
func Accept_Input():
	Car.SteeringInstance.is_drifting = Input.is_action_pressed("drift")
	
	update_action("left", "turn_left", Car.SteeringInstance)
	update_action("right", "turn_right", Car.SteeringInstance)
	
	Car.AccelerationInstance.is_accelerating = Input.is_action_pressed("forward")
	Car.AccelerationInstance.is_braking = Input.is_action_pressed("brake")


func update_action(action_name, property_name, target):
	if Input.is_action_just_pressed(action_name):
		target.set(property_name, true)
	elif Input.is_action_just_released(action_name):
		target.set(property_name, false)
