extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = %ProgressBar


func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)


func on_experience_updated(current: float, target: float):
	print(current)
	print(target)
	print('-----')
	progress_bar.value = current / target
