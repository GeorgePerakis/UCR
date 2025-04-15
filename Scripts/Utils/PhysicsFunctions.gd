extends Node
class_name PhysicsFunctions

func GetVelocityatLocalPosition(body: RigidBody3D, local_position: Vector3) -> Vector3:
	var world_position = body.to_global(local_position)
	var offset_vector = body.global_position - world_position 
	return body.linear_velocity + body.angular_velocity.cross(offset_vector)
