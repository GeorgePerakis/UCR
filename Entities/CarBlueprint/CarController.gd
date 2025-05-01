extends Node3D

@export var curve: Curve

@onready var SteeringScript = preload("res://Entities/CarBlueprint/Steering.gd")  
var SteeringInstance: Steering 

@onready var SuspensionScript = preload("res://Entities/CarBlueprint/Suspension.gd")  
var SuspensionInstance: Suspension

@onready var AccelerationScript = preload("res://Entities/CarBlueprint/Acceleration.gd")  
var AccelerationInstance: Acceleration

@onready var car: RigidBody3D = $"."
var suspensions: Dictionary

var angular_velocity : Vector3 = Vector3.ZERO

func _ready():
	InitScripts()
	InitCar()
	Engine.time_scale = 1

func _physics_process(delta):
	SuspensionInstance.ApplySuspensionForce(delta,suspensions,car)
	SteeringInstance.HandleSteering(suspensions)
	SteeringInstance.ApplySteeringForce(delta,suspensions,car)
	AccelerationInstance.HandleAcceleration(delta,suspensions,car,curve)
	
	angular_velocity = car.angular_velocity


func InitCar():
	suspensions = {
		"front_left": {"raycast": $Wheels/FL, "wheel": $Wheels/FL/Wheel, "length": Vector3.ZERO},
		"front_right": {"raycast": $Wheels/FR, "wheel": $Wheels/FR/Wheel, "length": Vector3.ZERO},
		"rear_left": {"raycast": $Wheels/BL, "wheel": $Wheels/BL/Wheel, "length": Vector3.ZERO},
		"rear_right": {"raycast": $Wheels/BR, "wheel": $Wheels/BR/Wheel, "length": Vector3.ZERO}
	}
	
	car.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	car.set_center_of_mass(Vector3(0, -0.4, 0))
	
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
