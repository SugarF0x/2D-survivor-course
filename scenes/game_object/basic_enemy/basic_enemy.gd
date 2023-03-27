extends CharacterBody2D

@onready var health_component: HealthComponent = %HealthComponent
@onready var visuals_node: Node2D = %Visuals
@onready var velocity_component: VelocityComponent = %VelocityComponent


func _process(delta):
	velocity_component.accelerate_to_player(self)
	velocity_component.move(self)
	flip_visuals_node_towards_movement()


func flip_visuals_node_towards_movement():
	var x_movement_vector_sign = sign(velocity.x)
	if x_movement_vector_sign != 0: visuals_node.scale.x = x_movement_vector_sign


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null: return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
