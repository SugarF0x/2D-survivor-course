extends CanvasLayer

@export var arean_time_manager: Node

@onready var label = %Label


func _process(delta):
	if arean_time_manager == null: return
	if label == null: return
	
	var time_elapsed = arean_time_manager.get_time_elapsed()
	label.text = str(floor(time_elapsed))
	
