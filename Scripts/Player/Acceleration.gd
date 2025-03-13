extends Node3D
class_name Acceleration

func HandleAcceleration(delta,suspensions,car):
	if Input.is_action_pressed("forward"):
		for key in suspensions:
			if key == "rear_left" || key == "rear_right":
				var suspension = suspensions[key]
				var wheel = suspension["wheel"]
				var raycast = suspension["raycast"]
				var wheel_z_axis = -wheel.global_transform.basis.x.normalized()
				
				#wheel_z_axis.y = 0
				#wheel_z_axis = wheel_z_axis.normalized()
				
				if raycast.is_colliding():
					car.apply_force((40 * wheel_z_axis * car.mass), wheel.global_position - car.global_position)
				
				DrawLine3d.DrawRay(
						wheel.global_position,
						10 * wheel_z_axis,
						Color.BLUE
					)
