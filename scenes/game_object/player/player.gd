extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@onready var collision_area = %CollisionArea2D as Area2D
@onready var damage_interval_timer = %DamageIntervalTimer as Timer
@onready var health_component = %HealthComponent as HealthComponent
@onready var health_bar = %HealthBar as ProgressBar

var colliding_body_number = 0

func _ready():
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(process_incoming_damage)
	health_component.health_changed.connect(on_health_changed)
	
	update_health_display()


func _process(delta):
	var direction = get_movement_vector().normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()


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
	print(health_component.current_health)


func on_body_entered(body: Node2D):
	colliding_body_number += 1
	process_incoming_damage()


func on_body_exited(body: Node2D):
	colliding_body_number -= 1


func on_health_changed(health: int):
	update_health_display()
