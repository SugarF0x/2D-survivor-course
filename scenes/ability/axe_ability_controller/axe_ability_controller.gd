extends Node

@export var axe_ability_scene: PackedScene

@onready var timer = $Timer

var damage = 10


func _ready():
	timer.timeout.connect(on_timer_timeout)


func spawn_axe():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null: return
	
	var foreground = get_tree().get_first_node_in_group('foreground_layer') as Node2D
	if foreground == null: return
	
	var axe_instance = axe_ability_scene.instantiate()
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage


func on_timer_timeout():
	spawn_axe()
