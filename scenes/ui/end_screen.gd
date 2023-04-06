extends CanvasLayer

@onready var title_label = %TitleLabel as Label
@onready var description_label = %DescriptionLabel as Label
@onready var restart_button = %RestartButton as Button
@onready var quit_button = %QuitButton as Button
@onready var panel_container = %PanelContainer as PanelContainer
@onready var victory_stream_player = $VictoryStreamPlayer
@onready var defeat_stream_player = $DefeatStreamPlayer

var defeat = false


func _ready():
	panel_container.pivot_offset = panel_container.size / 2

	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func set_defeat():
	defeat = true
	title_label.text = 'Defeat'
	description_label.text = 'You died'


func play_jingle():
	if defeat: defeat_stream_player.play()
	else: victory_stream_player.play()


func on_restart_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	get_tree().paused = false


func on_quit_pressed():
	get_tree().quit()
