extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D

@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var particles_node = $GPUParticles2D as GPUParticles2D


func _ready():
	particles_node.texture = sprite.texture
	health_component.died.connect(on_unit_died)


func on_unit_died():
	if owner == null || not owner is Node2D: return
	var spawn_position = (owner as Node2D).global_position
	
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	get_parent().remove_child(self)
	entities_layer.add_child(self)
	
	global_position = spawn_position
	animation_player.play('default')
