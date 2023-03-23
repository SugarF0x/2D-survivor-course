extends CanvasLayer

@onready var title_label = %TitleLabel as Label
@onready var description_label = %DescriptionLabel as Label
@onready var restart_button = %RestartButton as Button
@onready var quit_button = %QuitButton as Button


func _ready():
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func set_defeat():
	title_label.text = 'Defeat'
	description_label.text = 'You died'


func on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	get_tree().paused = false


func on_quit_pressed():
	get_tree().quit()
