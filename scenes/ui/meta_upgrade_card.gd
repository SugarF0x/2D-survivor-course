extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var purchase_button = $MarginContainer/VBoxContainer/PurchaseButton


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)

func set_meta_upgrade(upgrade: MetaUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_purchase_pressed():
	selected.emit()
