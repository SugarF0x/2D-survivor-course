extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@onready var collision_area = %CollisionArea2D as Area2D
@onready var damage_interval_timer = %DamageIntervalTimer as Timer
@onready var health_component = %HealthComponent as HealthComponent
@onready var health_bar = %HealthBar as ProgressBar
@onready var abilities_node = %Abilities as Node
@onready var visuals_node = %Visuals as Node2D

@onready var animation_player = $AnimationPlayer as AnimationPlayer

var colliding_body_number = 0

func _ready():
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(process_incoming_damage)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	update_health_display()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()
	flip_visuals_node_towards_movement(movement_vector)


func flip_visuals_node_towards_movement(movement_vector: Vector2):
	if movement_vector == Vector2.ZERO: animation_player.play('RESET')
	else: 
		animation_player.play('walk')
		
		var x_movement_vector_sign = sign(movement_vector.x)
		if x_movement_vector_sign != 0: visuals_node.scale.x = x_movement_vector_sign


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func process_incoming_damage():
	if colliding_body_number <= 0: return
	if not damage_interval_timer.is_stopped(): return
	damage_interval_timer.start()
	health_component.apply_damage(1)


func on_body_entered(body: Node2D):
	colliding_body_number += 1
	process_incoming_damage()


func on_body_exited(body: Node2D):
	colliding_body_number -= 1


func on_health_changed(health: int):
	update_health_display()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, all_upgrades: Dictionary):
	if not upgrade is Ability: return
	var ability = upgrade as Ability
	abilities_node.add_child(ability.ability_controller_scene.instantiate())
