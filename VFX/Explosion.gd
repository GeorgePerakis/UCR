extends Node3D

@onready var fire: GPUParticles3D = $Fire
@onready var debris: GPUParticles3D = $Debris
@onready var smoke: GPUParticles3D = $Smoke
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func explode():
	fire.emitting = true
	debris.emitting = true
	smoke.emitting = true
	audio_stream_player_3d.play()
	
	await get_tree().create_timer(2).timeout
	queue_free()
