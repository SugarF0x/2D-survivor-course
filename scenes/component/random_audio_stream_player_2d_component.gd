extends AudioStreamPlayer2D
class_name RandomAudioStreamPlayer2DComponent

@export var streams: Array[AudioStream]
@export var randomize_pitch = true
@export var max_pitch = 1.1
@export var min_pitch = .9


func play_random():
	if streams == null || streams.size() == 0: return
	
	if randomize_pitch: pitch_scale = randf_range(min_pitch, max_pitch)
	else: randomize_pitch = 1
	
	stream = streams.pick_random()
	play()
