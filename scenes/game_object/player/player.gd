extends CharacterBody2D

@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var health_component = %HealthComponent as HealthComponent
@onready var abilities_node = %Abilities as Node
@onready var velocity_component = $VelocityComponent as VelocityComponent
@onready var damage_interval_timer = %DamageIntervalTimer as Timer
@onready var visuals_node = %Visuals as Node2D
@onready var health_bar = %HealthBar as ProgressBar
@onready var collision_area = %CollisionArea2D as Area2D

var colliding_body_number = 0
var move_speed_multiplier = 1


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
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)

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
	
	var damage = 1
	damage_interval_timer.start()
	health_component.apply_damage(damage)
	GameEvents.emit_player_hit(damage, health_component.current_health)


func handle_new_ability_addition(upgrade: AbilityUpgrade):
	if not upgrade is Ability: return
	var ability = upgrade as Ability
	abilities_node.add_child(ability.ability_controller_scene.instantiate())


func handle_speed_upgrade(quantity: int):
	move_speed_multiplier = 1 + quantity * .25
	velocity_component.speed = velocity_component.base_speed * move_speed_multiplier

func on_body_entered(body: Node2D):
	colliding_body_number += 1
	process_incoming_damage()


func on_body_exited(body: Node2D):
	colliding_body_number -= 1


func on_health_changed(health: int):
	update_health_display()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, all_upgrades: Dictionary):
	handle_new_ability_addition(upgrade)
	
	match (upgrade.id):
		"player_speed": handle_speed_upgrade(all_upgrades["player_speed"]["quantity"])
