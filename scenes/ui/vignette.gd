extends CanvasLayer

@onready var animation_player = $AnimationPlayer


func _ready():
	GameEvents.player_hit.connect(on_player_hit)


func on_player_hit(damage: int, current_health: int):
	animation_player.play('hit')
