extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component: HealthComponent = %HealthComponent
@onready var visuals_node: Node2D = %Visuals


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	
	move_and_slide()
	flip_visuals_node_towards_movement(direction)


func flip_visuals_node_towards_movement(movement_vector: Vector2):
	var x_movement_vector_sign = sign(movement_vector.x)
	if x_movement_vector_sign != 0: visuals_node.scale.x = x_movement_vector_sign


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
