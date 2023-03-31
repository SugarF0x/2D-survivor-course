extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var hover_animation_player = $HoverAnimationPlayer

var disabled = false


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play('in')


func play_selected(delay: float = 0): 
	animation_player.play('selected')


func play_discard(delay: float = 0):
	animation_player.play('discard')


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card():
	disabled = true
	play_selected()
	
	var other_upgrade_cards = get_tree().get_nodes_in_group('upgrade_card')\
		.filter(func (card): return card != self)
	
	for other_card_index in other_upgrade_cards.size():
		var other_card = other_upgrade_cards[other_card_index]
		other_card.play_discard(other_card_index * .2)
	
	await animation_player.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent):
	if disabled: return
	if event.is_action_pressed("left_click"): select_card()
		


func on_mouse_entered():
	if disabled: return
	hover_animation_player.play('hover')
