extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = $MarginContainer/GridContainer
@onready var sound_button = %SoundButton

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
	sound_button.pressed.connect(on_back_pressed)
	
	# remove dev-only cards
	for card in grid_container.get_children(): card.queue_free()
	
	for upgrade in upgrades:
		var upgrade_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(upgrade_instance)
		upgrade_instance.set_meta_upgrade(upgrade)


func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
