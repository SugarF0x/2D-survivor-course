extends CharacterBody2D

@onready var visuals_node: Node2D = %Visuals
@onready var velocity_component: VelocityComponent = %VelocityComponent
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var hurtbox_component = $HurtboxComponent


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(delta):
	velocity_component.accelerate_to_player(self)
	velocity_component.move(self)
	flip_visuals_node_towards_movement()


func flip_visuals_node_towards_movement():
	var x_movement_vector_sign = sign(velocity.x)
	if x_movement_vector_sign != 0: visuals_node.scale.x = x_movement_vector_sign


func on_hit():
	audio_stream_player_2d.play()
