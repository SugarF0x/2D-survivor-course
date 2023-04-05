extends CanvasLayer

signal back_pressed

@onready var window_mode_button = %WindowModeButton
@onready var sfxh_slider = %SFXHSlider
@onready var music_h_slider = %MusicHSlider
@onready var back_button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_button_pressed)
	
	window_mode_button.pressed.connect(on_window_mode_button_pressed)
	
	sfxh_slider.value_changed.connect(on_audio_slider_value_changed.bind('sfx'))
	music_h_slider.value_changed.connect(on_audio_slider_value_changed.bind('music'))
	
	update_display()


func update_display():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN: window_mode_button.text = "Windowed"
	else: window_mode_button.text = "Fullscreen"
	
	sfxh_slider.value = get_bus_volume_value('sfx')
	music_h_slider.value = get_bus_volume_value('music')


func get_bus_volume_value(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func on_audio_slider_value_changed(value: float, bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_window_mode_button_pressed():
	var mode = DisplayServer.window_get_mode()
	
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


func on_back_button_pressed():
	back_pressed.emit()

