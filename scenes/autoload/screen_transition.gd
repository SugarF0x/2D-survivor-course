extends CanvasLayer

signal transition_halfway

@onready var animation_player = $AnimationPlayer

var did_emit = false


func transition():
	animation_player.play('default')
	await animation_player.animation_finished
	animation_player.play_backwards('default')
	await animation_player.animation_finished
	did_emit = false


func transition_to_scene(path: String):
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().change_scene_to_file(path)


func emit_halfway():
	if did_emit: return
	did_emit = true
	
	transition_halfway.emit()
