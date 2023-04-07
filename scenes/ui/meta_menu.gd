extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = $MarginContainer/GridContainer

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
	for upgrade in upgrades:
		var upgrade_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(upgrade_instance)
		upgrade_instance.set_meta_upgrade(upgrade)
