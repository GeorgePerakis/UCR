extends Node3D
@onready var Car := $Car as Node
@onready var CarController = Car.get_script() 

@export var player_node: NodePath

var player

func _ready():
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		
func _process(delta: float) -> void:
	update_ai_behavior()

func update_ai_behavior():
	var direction_to_player = (player.global_position - Car.global_position).normalized()
	var ai_forward = Car.global_transform.basis.z.normalized()
	
	var angle_to_player = ai_forward.angle_to(direction_to_player)
	var cross = ai_forward.cross(direction_to_player).y
	
	var distance = Car.global_position.distance_to(player.global_position)
	var stopping_distance = 5.0 

	Car.AccelerationInstance.is_accelerating = distance > stopping_distance
	Car.AccelerationInstance.is_braking = distance <= stopping_distance
	
	var turn_threshold = 0.05 

	if angle_to_player > turn_threshold:
		Car.SteeringInstance.turn_left = cross > 0
		Car.SteeringInstance.turn_right = cross < 0
	else:
		Car.SteeringInstance.turn_left = false
		Car.SteeringInstance.turn_right = false

	
	# Optional: Stop drifting for AI
	Car.SteeringInstance.is_drifting = false
	DrawLine3d.DrawRay(
				Car.global_position,
				direction_to_player,
				Color.PURPLE
			)
