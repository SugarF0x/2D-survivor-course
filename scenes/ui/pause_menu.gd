extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var panel_container = $MarginContainer/PanelContainer
@onready var resume_button = %ResumeButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton

var options_scene: PackedScene = preload('res://scenes/ui/options_menu.tscn')

var is_closing = false


func _ready():
	get_tree().paused = true
	
	resume_button.pressed.connect(close)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	animation_player.play('default')
	
	panel_container.pivot_offset = panel_container.size / 2
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event):
	if not event.is_action_pressed('pause'): return
	
	get_tree().root.set_input_as_handled()
	close()


func close():
	if is_closing: return
	is_closing = true
	
	animation_player.play_backwards('default')
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()
	

func on_options_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_options_closed(node: Node):
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	node.queue_free()


func on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	
