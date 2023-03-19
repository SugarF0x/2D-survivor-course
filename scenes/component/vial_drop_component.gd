extends Node
class_name VialDropComponent

@export var vial_scene: PackedScene
@export var health_component: HealthComponent


func _ready():
	health_component.died.connect(on_died)


func on_died():
	if vial_scene == null: return
	if not owner is Node2D: return
	
	var vial_instance = vial_scene.instantiate() as Node2D
	owner.get_parent().add_child(vial_instance)
	vial_instance.global_position = owner.global_position
