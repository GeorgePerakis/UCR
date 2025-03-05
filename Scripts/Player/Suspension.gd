extends Node3D
class_name Suspension

@export var suspension_length : float = 1.0
var suspension_strength : float = 350
var damping_strength : float = 50
var wheel_radius : float = 0.5

func ApplySuspensionForce(delta,suspensions,car):
	for key in suspensions:
		var suspension = suspensions[key]
		var raycast = suspension["raycast"]
		var previous_position = suspension["length"]
		var wheel = suspension["wheel"]
		
		var origin = raycast.global_position
		var collision_point = raycast.get_collision_point()
		
		var current_length = origin.distance_to(collision_point)
		
		var compression_ratio = suspension_length - current_length
		var force_direction = raycast.global_transform.basis.y.normalized()
		
		var suspension_force = force_direction * compression_ratio * suspension_strength
		
		var velocity = (previous_position - origin) / delta
		suspension["length"] = origin
		var damping_force = velocity * damping_strength
		
		var force = suspension_force + damping_force
		
		if raycast.is_colliding():
			car.apply_force(force, origin - car.global_position)
			wheel.global_position = collision_point + Vector3(0, wheel_radius, 0)
			
			DrawLine3d.DrawRay(
				origin,
				(force - (origin - car.global_position)).normalized(),
				Color.RED
			)
		else:
			wheel.position = -Vector3(0, suspension_length - wheel_radius, 0)
