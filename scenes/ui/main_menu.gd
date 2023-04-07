extends CanvasLayer

@onready var play_button = %PlayButton
@onready var meta_button = %MetaButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton

var options_scene: PackedScene = preload('res://scenes/ui/options_menu.tscn')


func _ready():
	play_button.pressed.connect(on_play_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	meta_button.pressed.connect(on_meta_button_pressed)


func on_play_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/main/main.tscn")


func on_meta_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/meta_menu.tscn")


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
	get_tree().quit()
