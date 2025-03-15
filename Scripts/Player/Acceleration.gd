extends Node3D
class_name Acceleration

func HandleAcceleration(delta,suspensions,car):
	if Input.is_action_pressed("forward"):
		for key in suspensions:
			if key == "rear_left" || key == "rear_right":
				var suspension = suspensions[key]
				var wheel = suspension["wheel"]
				var raycast = suspension["raycast"]
				var car_z_axis = car.global_transform.basis.z.normalized()
				car_z_axis.y = 0
				car_z_axis = car_z_axis.normalized()
				
				if raycast.is_colliding():
					var local_offset = Vector3(0, -0.2, 0.3) 
					var global_offset = car.global_transform.origin + car.global_transform.basis * local_offset
					car.apply_force((80 * car_z_axis * car.mass), global_offset - car.global_position)
				
					DrawLine3d.DrawRay(
							car.global_transform.origin + car.global_transform.basis * Vector3(0, 0.1, 0.1),
							10 * car_z_axis,
							Color.BLUE
						)
