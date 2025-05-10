extends Node3D
class_name Acceleration

var is_accelerating = false
var is_braking = false

var engine_force = 4500
var max_speed = 25
var force_multiplier
var drag_coefficient = 1300

var local_offset = Vector3(0, -0.8, 0.2)

func HandleAcceleration(suspensions,car,curve):
	var one_wheel_grounded = false
	
	for key in suspensions:
		var raycast = suspensions[key]["raycast"]
		if raycast.is_colliding():
			one_wheel_grounded = true
		
		if not one_wheel_grounded:
			return  
		
		var velocity = car.linear_velocity
		var speed = velocity.dot(car.global_transform.basis.z)
		var car_z_axis = car.global_transform.basis.z.normalized()
		
		var suspension = suspensions[key]
		
		if raycast.is_colliding():
			var normalized_speed = clamp(speed / max_speed, 0.0, 1.0)
			
			if(normalized_speed != 1):
				force_multiplier = curve.sample(normalized_speed)
			else:
				force_multiplier = 0
			
			var force = engine_force * force_multiplier
			var world_offset = car.to_global(local_offset)
			
			if is_accelerating:
				car.apply_force((force * car_z_axis),world_offset - car.global_position)
			elif is_braking and normalized_speed > 0.01:
				car.apply_force((force * 2 * -car_z_axis),world_offset - car.global_position)
			
			if !is_accelerating and !is_braking:
				var drag_force = -car.linear_velocity.normalized() * drag_coefficient
				car.apply_central_force(drag_force)
			
			if Debug.isOn:
				DrawLine3d.DrawRay(
						world_offset,
						car.linear_velocity.dot(car.global_transform.basis.z) * car.global_transform.basis.z.normalized(),
						Color.BLUE
					)
