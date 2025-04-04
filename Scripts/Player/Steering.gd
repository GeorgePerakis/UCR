extends Node
class_name Steering

@onready var PhysicsScript = preload("res://Scripts/Utils/PhysicsFunctions.gd")  
@onready var PhysicsFunctionsInstance: PhysicsFunctions = PhysicsFunctions.new()

var target_angle : float = CENTER_ROTATION
var current_angle : float
var rotation_speed = 100.0 

var front_grip_default = 0.3
var rear_grip_default = 0.5
var front_grip_drift = 0.1
var rear_grip_drift = 0.2

var front_grip = front_grip_default
var rear_grip = rear_grip_default

const LEFT_ROTATION = deg_to_rad(-50)
const RIGHT_ROTATION = deg_to_rad(-130)
const CENTER_ROTATION = deg_to_rad(-90)

func _process(delta):
	if Input.is_action_pressed("drift"):
		front_grip = front_grip_drift
		rear_grip = rear_grip_drift
	else:
		front_grip = front_grip_default
		rear_grip = rear_grip_default

func HandleSteering(suspensions):
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

func ApplySteeringForce(delta,suspensions,car):
	for key in suspensions:
		var suspension = suspensions[key]
		var wheel = suspension["wheel"]
		var raycast = suspension["raycast"]
		var wheel_x_axis
		
		if key == "front_left" || key == "rear_left":
			wheel_x_axis = wheel.global_transform.basis.y.normalized()
		else:
			wheel_x_axis = -wheel.global_transform.basis.y.normalized()
		
		var wheel_velocity = PhysicsFunctionsInstance.GetVelocityatLocalPosition(car,wheel.position)
		
		var force = (-(wheel_velocity.dot(wheel_x_axis) * wheel_x_axis) * car.mass) / delta * 0.05
		
		if Input.is_action_pressed("drift") and (key == "rear_left" or key == "rear_right"):
			var drift_factor = 0.3  # Reduce lateral grip when drifting
			force *= drift_factor
		
		if raycast.is_colliding():
			if key == "front_left" || key == "front_right":
				car.apply_force(force * front_grip, wheel.global_position - car.global_position)
			elif key == "rear_left" || key == "rear_right":
				car.apply_force(force * rear_grip, wheel.global_position - car.global_position)
		
		DrawLine3d.DrawRay(
				wheel.global_position,
				wheel_velocity.dot(wheel_x_axis) * wheel_x_axis,
				Color.RED
			)
