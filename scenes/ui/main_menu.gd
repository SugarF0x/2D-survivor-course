extends CanvasLayer

@onready var play_button = %PlayButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton


func _ready():
	play_button.pressed.connect(on_play_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")


func on_quit_button_pressed():
	get_tree().quit()

