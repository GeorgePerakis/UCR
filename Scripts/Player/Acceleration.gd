extends Node3D
class_name Acceleration

var forward_force = 9000
var max_speed = 20
var force_multiplier

func HandleAcceleration(delta,suspensions,car,curve):
	if Input.is_action_pressed("forward"):
		for key in suspensions:
			var velocity = car.linear_velocity
			var speed = velocity.dot(car.global_transform.basis.z)
			var car_z_axis = car.global_transform.basis.z.normalized()
			
			if key == "rear_left" || key == "rear_right":
				var suspension = suspensions[key]
				var wheel = suspension["wheel"]
				var raycast = suspension["raycast"]
				
				
				if raycast.is_colliding():
					var normalized_speed = clamp(speed / max_speed, 0.0, 1.0)
					
					if(normalized_speed != 1):
						force_multiplier = curve.sample(normalized_speed)
					else:
						force_multiplier = 0
					
					var force = forward_force * force_multiplier
					
					car.apply_force((force * car_z_axis), wheel.global_position - car.global_position)
				
	DrawLine3d.DrawRay(
			car.global_position,
			car.linear_velocity.dot(car.global_transform.basis.z) * car.global_transform.basis.z.normalized(),
			Color.BLUE
		)
