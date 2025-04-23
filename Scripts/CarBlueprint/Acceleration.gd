extends Node3D
class_name Acceleration

var is_accelerating = false
var is_braking = false

var engine_force = 9500
var max_speed = 25
var force_multiplier

var local_offset = Vector3(0, 0, -4)

func HandleAcceleration(delta,suspensions,car,curve):
	for key in suspensions:
		var velocity = car.linear_velocity
		var speed = velocity.dot(car.global_transform.basis.z)
		var car_z_axis = car.global_transform.basis.z.normalized()
		car_z_axis.y = 0
		car_z_axis = car_z_axis.normalized()
		
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
				
				var force = engine_force * force_multiplier
				
				var force_position = wheel.global_position
				
				
				if is_accelerating:
					car.apply_force((force * car_z_axis),force_position - car.global_position)
				elif is_braking:
					if normalized_speed > 0.01:
						car.apply_force((force * 2 * -car_z_axis),force_position - car.global_position)
				
	DrawLine3d.DrawRay(
			car.global_position,
			car.linear_velocity.dot(car.global_transform.basis.z) * car.global_transform.basis.z.normalized(),
			Color.BLUE
		)
