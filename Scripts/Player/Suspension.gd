extends Node3D
class_name Suspension

@export var suspension_length : float = 0.5
var suspension_strength : float = 280000
var damping_strength : float = 7500
var wheel_radius : float = 0.35

func ApplySuspensionForce(delta,suspensions,car):
	for key in suspensions:
		var suspension = suspensions[key]
		var wheel = suspension["wheel"]
		var raycast = suspension["raycast"]
		var previous_position = suspension["length"]
		
		var origin = raycast.global_position
		var collision_point = raycast.get_collision_point()
		
		var current_length = origin.distance_to(collision_point)
		
		if current_length > suspension_length:
			current_length = suspension_length
		
		var compression_ratio = suspension_length - current_length
		var force_direction = raycast.global_transform.basis.y.normalized()
		
		var suspension_force = force_direction * compression_ratio * suspension_strength
		
		var velocity = (previous_position - origin) / delta
		suspension["length"] = origin
		var damping_force = velocity * damping_strength
		
		var force = suspension_force + damping_force
		
		if raycast.is_colliding():
			car.apply_force(Vector3(0,force.y,0), origin - car.global_position)
			
			var wheel_position_y = collision_point.y + wheel_radius
			wheel.global_position.y = wheel_position_y
			
			
			DrawLine3d.DrawRay(
				origin,
				(Vector3(0,force.y,0) - (origin - car.global_position)).normalized(),
				Color.GREEN
			)
		else:
			var target_wheel_position = raycast.global_position - raycast.global_transform.basis.y * (suspension_length - wheel_radius)
			wheel.global_position = wheel.global_position.lerp(target_wheel_position, 0.1)
