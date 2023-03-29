extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn") as PackedScene


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	if health_component == null: return
	
	if not area is HitboxComponent: return
	var hitbox_component = area as HitboxComponent
	
	var damage = hitbox_component.damage
	health_component.apply_damage(damage)
	spawn_floating_text(damage)


func spawn_floating_text(damage: int):
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group('foreground_layer').add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(str(damage))
