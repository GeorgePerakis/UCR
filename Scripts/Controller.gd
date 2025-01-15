extends Node3D

@export var suspension_length : float = 1
@export var suspension_strength : float = 350
var car: RigidBody3D
var suspensions: Dictionary
var damping_strength : float = 50
var wheel_radius : float = 0.5
var frame : int = 0

func _ready():
	InitCar()

func _physics_process(delta):
	ApplySusForce(delta)

func InitCar():
	car = $Body
	suspensions = {
	"front_left": {"raycast": $Body/Wheels/FL, "wheel": $Body/Wheels/FL/Wheel, "length": Vector3.ZERO},
	"front_right": {"raycast": $Body/Wheels/FR, "wheel": $Body/Wheels/FR/Wheel, "length": Vector3.ZERO},
	"rear_left": {"raycast": $Body/Wheels/BL, "wheel": $Body/Wheels/BL/Wheel, "length": Vector3.ZERO},
	"rear_right": {"raycast": $Body/Wheels/BR, "wheel": $Body/Wheels/BR/Wheel, "length": Vector3.ZERO}
	}
	car.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	car.set_center_of_mass(Vector3(0, -0.5, 0))
	Engine.time_scale = 1
	for key in suspensions:
		var suspension = suspensions[key]
		suspension["raycast"].target_position = Vector3(0, -suspension_length, 0)
		suspension["raycast"].visible = true
		suspension["position"] = suspension["raycast"].global_transform.origin

func ApplySusForce(delta):
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
			if(key == "front_left"):
				print("CURRENT SNAPSHOT ",frame)
				frame += 1
				print("force: ", force)
			car.apply_force(force,origin - car.global_position)
			wheel.global_position = collision_point + Vector3(0,wheel_radius,0)
			
			DrawLine3d.DrawRay(
			origin,
			(force - (origin - car.global_position)).normalized(),
			Color.RED
			)
			
		else:
			wheel.position = -Vector3(0,suspension_length - wheel_radius,0)
			
