extends Node

var current_experience = 0


func _ready():
	GameEvents.experience_vial_collected.connect(increase_experience)


func increase_experience(val: float):
	current_experience += val
	print(current_experience)
