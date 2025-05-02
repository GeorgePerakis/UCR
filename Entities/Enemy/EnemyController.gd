extends Node3D
@onready var Car := $Car as Node
@onready var CarController = Car.get_script()

var player
var target

var turn_threshold = 0.1
var drift_threshold = 0.8

var path
var path_follow
var speed = 15

func _ready():
	init_enemy_scene()

func _process(delta: float) -> void:
	path_follow.progress += delta * speed
	update_ai_behavior()

func update_ai_behavior():
	chase_target(path_follow.global_position)
	
	#var distance = Car.global_position.distance_to(target_position)
	#var stopping_distance = 20.0 

	Car.AccelerationInstance.is_accelerating = true
	#Car.AccelerationInstance.is_braking = distance <= stopping_distance

func chase_target(target):
	var direction_to_target = (target - Car.global_position).normalized()
	var forward = Car.global_transform.basis.z.normalized()
	
	var angle_to_target = forward.angle_to(direction_to_target)
	var cross = forward.cross(direction_to_target).y
	
	if angle_to_target > turn_threshold:
		Car.SteeringInstance.turn_left = cross > 0
		Car.SteeringInstance.turn_right = cross < 0
		if angle_to_target > drift_threshold:
			Car.SteeringInstance.is_drifting = true
		else:
			Car.SteeringInstance.is_drifting = false
	else:
		Car.SteeringInstance.turn_left = false
		Car.SteeringInstance.turn_right = false

func init_enemy_scene():
	await get_tree().process_frame
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	
	path_follow = PathFollow3D.new()
	path.add_child(path_follow)
	#Car.SteeringInstance.is_ai = true
