extends Node
class_name VelocityComponent

@export var base_speed: int = 40
@export var acceleration: float = 5

var speed: int
var velocity = Vector2.ZERO


func _ready():
	speed = base_speed


func accelerate_to_player(character_body: CharacterBody2D):
	var player = get_tree().get_first_node_in_group('player') as CharacterBody2D
	if player == null: return
	
	var direction = (player.global_position - character_body.global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func decelerate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
