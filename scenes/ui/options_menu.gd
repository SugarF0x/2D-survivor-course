extends CanvasLayer

@onready var window_mode_button = %WindowModeButton
@onready var sfxh_slider = %SFXHSlider
@onready var music_h_slider = %MusicHSlider
@onready var back_button = %BackButton


func _ready():
	window_mode_button.pressed.connect(on_window_mode_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	
	update_window_button_text()


func update_window_button_text():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN: window_mode_button.text = "Windowed"
	else: window_mode_button.text = "Fullscreen"

func on_window_mode_button_pressed():
	var mode = DisplayServer.window_get_mode()
	
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_window_button_text()


func on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

