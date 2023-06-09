extends Node
class_name VialDropComponent

@export_range(0, 1) var drop_rate: float = .5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene


func _ready():
	health_component.died.connect(on_died)


func on_died():
	var adjusted_drop_rate = min(drop_rate * (1 + .1 * MetaProgression.get_upgrade_count("experience_gain")), 1)
	
	if vial_scene == null: return
	if not owner is Node2D: return
	if randf() > adjusted_drop_rate: return
	
	var vial_instance = vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group('entities_layer') as Node2D
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = owner.global_position
