extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	if health_component == null: return
	
	if not area is HitboxComponent: return
	var hitbox_component = area as HitboxComponent
	
	health_component.apply_damage(hitbox_component.damage)
