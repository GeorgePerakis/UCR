extends Node3D

@onready var SteeringScript = preload("res://Scripts/Player/Steering.gd")  
var SteeringInstance: Steering 

@onready var SuspensionScript = preload("res://Scripts/Player/Suspension.gd")  
var SuspensionInstance: Suspension

@onready var AccelerationScript = preload("res://Scripts/Player/Acceleration.gd")  
var AccelerationInstance: Acceleration

@onready var car: RigidBody3D = $Body
var suspensions: Dictionary

func _ready():
	InitScripts()
	InitCar()
	Engine.time_scale = 1

func _physics_process(delta):
	SuspensionInstance.ApplySuspensionForce(delta,suspensions,car)
	SteeringInstance.ApplySteeringForce(delta,suspensions,car)
	AccelerationInstance.HandleAcceleration(delta,suspensions,car)

func _input(_event):
	SteeringInstance.HandleSteering(suspensions)

func InitCar():
	suspensions = {
		"front_left": {"raycast": $Body/Wheels/FL, "wheel": $Body/Wheels/FL/Wheel, "length": Vector3.ZERO},
		"front_right": {"raycast": $Body/Wheels/FR, "wheel": $Body/Wheels/FR/Wheel, "length": Vector3.ZERO},
		"rear_left": {"raycast": $Body/Wheels/BL, "wheel": $Body/Wheels/BL/Wheel, "length": Vector3.ZERO},
		"rear_right": {"raycast": $Body/Wheels/BR, "wheel": $Body/Wheels/BR/Wheel, "length": Vector3.ZERO}
	}
	
	car.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	car.set_center_of_mass(Vector3(0, -0.2, 0))
	
	for key in suspensions:
		var suspension = suspensions[key]
		suspension["raycast"].target_position = Vector3(0, -SuspensionInstance.suspension_length, 0)
		suspension["position"] = suspension["raycast"].global_transform.origin

func InitScripts():
	SteeringInstance = SteeringScript.new() 
	self.add_child(SteeringInstance)
	
	SuspensionInstance = SuspensionScript.new() 
	self.add_child(SuspensionInstance) 
	
	AccelerationInstance = AccelerationScript.new() 
	self.add_child(AccelerationInstance) 
