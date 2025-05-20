extends Node
class_name Steering

@onready var PhysicsScript = preload("res://Utils/PhysicsFunctions.gd")  
@onready var PhysicsFunctionsInstance: PhysicsFunctions = PhysicsFunctions.new()

var threeshold = 0.5

var is_drifting = false
var turn_left = false
var turn_right = false
var is_ai = false

var target_angle : float = CENTER_ROTATION
var current_angle : float
var rotation_speed = 100.0 

var front_grip_default = 0.1
var rear_grip_default = 0.3
var front_grip_drift = 0.15
var rear_grip_drift = 0.2
var grip_lerp_speed = 2

var front_grip = front_grip_default
var rear_grip = rear_grip_default

var max_steering_force = 80

const LEFT_ROTATION = deg_to_rad(40)
const RIGHT_ROTATION = deg_to_rad(-40)
const CENTER_ROTATION = deg_to_rad(0)

func _process(delta):
	var target_front = front_grip_default
	var target_rear = rear_grip_default
	
	if is_drifting:
		front_grip = front_grip_drift
		rear_grip = rear_grip_drift

	front_grip = lerp(front_grip, target_front, grip_lerp_speed * delta)
	rear_grip = lerp(rear_grip, target_rear, grip_lerp_speed * delta)

func HandleSteering(suspensions):
	if turn_left and (target_angle == LEFT_ROTATION or target_angle == CENTER_ROTATION):
		target_angle = LEFT_ROTATION
	elif turn_right and (target_angle == RIGHT_ROTATION or target_angle == CENTER_ROTATION):
		target_angle = RIGHT_ROTATION
	elif !turn_left and (target_angle == LEFT_ROTATION):
		target_angle = CENTER_ROTATION
	elif !turn_right and (target_angle == RIGHT_ROTATION):
		target_angle = CENTER_ROTATION
		
	RotateWheels(suspensions)

func RotateWheels(suspensions):
	var has_input = absf(Input.get_axis("left", "right"))
	
	if has_input != 0:
		suspensions["front_left"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle) * has_input
		suspensions["front_right"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle) * has_input
	else:
		suspensions["front_left"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle)
		suspensions["front_right"]["wheel"].rotation_degrees.y = rad_to_deg(target_angle)

func ApplySteeringForce(delta,suspensions,car):
	for key in suspensions:
		var suspension = suspensions[key]
		var raycast = suspension["raycast"]
		
		if raycast.is_colliding():
			
			var wheel = suspension["wheel"]
			
			var velocity_change
			
			var wheel_x_axis = wheel.global_transform.basis.x.normalized()
			
			var wheel_velocity = PhysicsFunctionsInstance.GetVelocityatLocalPosition(car,wheel.position)
			
			var steering_velocity = wheel_velocity.dot(wheel_x_axis)
			
			if key == "front_left" or key == "front_right":
				velocity_change = -steering_velocity * front_grip
			elif key == "rear_left" or key == "rear_right":
				velocity_change = -steering_velocity * rear_grip
			
			var acceleration = velocity_change / delta
			
			var force = acceleration
			
			car.apply_force(force * wheel_x_axis * max_steering_force, wheel.global_position - car.global_position)
			
			if Debug.isOn:
				DrawLine3d.DrawRay(
					wheel.global_position,
					(force * wheel_x_axis) / 100,
					Color.RED
				)
		
