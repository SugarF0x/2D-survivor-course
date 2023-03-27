extends CharacterBody2D

@onready var visuals_node: Node2D = $Visuals
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _process(delta):
	velocity_component.accelerate_to_player(self)
	velocity_component.move(self)
	flip_visuals_node_towards_movement()


func flip_visuals_node_towards_movement():
	var x_movement_vector_sign = sign(velocity.x)
	if x_movement_vector_sign != 0: visuals_node.scale.x = x_movement_vector_sign
