extends Node
class_name HealthComponent

signal died
signal health_changed(new_value: int, delta: int)

@export var max_health = 10
var current_health


func _ready():
	current_health = max_health


func set_health(value: int):
	var new_value = clamp(value, 0, max_health)
	if new_value == current_health: return
	
	health_changed.emit(new_value, value - current_health)
	current_health = new_value


func add_health(value: int):
	set_health(current_health + value)


func apply_damage(number: int):
	add_health(-number)
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0: 
		died.emit()
		owner.queue_free()


func get_health_percent():
	if max_health <= 0: return 0
	return min(float(current_health) / max_health, 1)
