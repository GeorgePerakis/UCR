extends Camera3D

@export var duration = 0.2
@export var magnitude = 0.2

func _ready():
	SignalBus.connect("enemy_died", Callable(self, "_on_enemy_died"))

func _on_enemy_died():
	screen_shake()
	
func screen_shake():
	var start_position = self.position
	var elapsed_time = 0.0

	while elapsed_time < duration:
		var decay = 1.0 - (elapsed_time / duration)
		var offset = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			0
		) * magnitude * decay
		
		self.position = start_position + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.position = start_position
