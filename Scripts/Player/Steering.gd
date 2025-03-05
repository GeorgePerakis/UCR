extends Node
class_name Steering

var target_angle : float = CENTER_ROTATION
var current_angle : float
var rotation_speed = 100.0 

const LEFT_ROTATION = deg_to_rad(-30)
const RIGHT_ROTATION = deg_to_rad(30)
const CENTER_ROTATION = deg_to_rad(90)

func HandleInput(suspensions):
	if Input.is_action_just_pressed("left") and (target_angle == LEFT_ROTATION or target_angle == CENTER_ROTATION):
		target_angle = LEFT_ROTATION
		RotateWheels(suspensions)
	elif Input.is_action_just_pressed("right") and (target_angle == RIGHT_ROTATION or target_angle == CENTER_ROTATION):
		target_angle = RIGHT_ROTATION
		RotateWheels(suspensions)
	elif Input.is_action_just_released("left") and (target_angle == LEFT_ROTATION):
		target_angle = CENTER_ROTATION
		RotateWheels(suspensions)
	elif Input.is_action_just_released("right") and (target_angle == RIGHT_ROTATION):
		target_angle = CENTER_ROTATION
		RotateWheels(suspensions)

func RotateWheels(suspensions):
	var current_axis: float = absf(Input.get_axis("left", "right"))
	if current_axis != 0:
		suspensions["front_left"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle) * current_axis
		suspensions["front_right"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle) * current_axis
	else:
		suspensions["front_left"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle)
		suspensions["front_right"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle)
