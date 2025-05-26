extends Node3D
class_name Acceleration

var is_accelerating: bool = false
var is_braking: bool = false

var engine_force: int = 4500 * 4
var max_speed: int = 25
var force_multiplier: float = 1.0
var drag_coefficient: int = 1300
var brake_multiplier: int = 2

var one_wheel_grounded: bool = false
var local_offset: Vector3 = Vector3(0, -0.8, 0.2)

func HandleAcceleration(suspensions: Dictionary, car: RigidBody3D, curve: Curve):
	one_wheel_grounded = false

	for key in suspensions:
		if suspensions[key]["raycast"].is_colliding():
			one_wheel_grounded = true
			break
	
	if not one_wheel_grounded:
		return

	var velocity = car.linear_velocity
	var speed = velocity.dot(car.global_transform.basis.z)
	var normalized_speed = clamp(speed / max_speed, 0.0, 1.0)
	var car_z_axis = car.global_transform.basis.z.normalized()
	force_multiplier = curve.sample(normalized_speed) if normalized_speed < 1.0 else 0.0

	var force = engine_force * force_multiplier
	var world_offset = car.to_global(local_offset)

	if is_accelerating:
		car.apply_force(force * car_z_axis, world_offset - car.global_position)
	elif is_braking and normalized_speed > 0.01:
		car.apply_force(force * brake_multiplier * -car_z_axis, world_offset - car.global_position)
	else:
		var drag_force = -velocity.normalized() * drag_coefficient
		car.apply_central_force(drag_force)

	if Debug.isOn:
		var debug_vector = speed * car_z_axis
		DrawLine3d.DrawRay(world_offset, debug_vector, Color.BLUE)
