extends Node
class_name HealthComponent

signal died

@export var max_health = 10
var current_health


func _ready():
	current_health = max_health


func apply_damage(number: float):
	current_health = max(current_health - number, 0)
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0: 
		died.emit()
		owner.queue_free()
