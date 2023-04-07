extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_label = %ProgressLabel
@onready var count_label = %CountLabel
@onready var progress_bar = %ProgressBar
@onready var purchase_button = %PurchaseButton

var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func update_progress():
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = min(float(currency) / upgrade.experience_cost, 1)
	var quantity = MetaProgression.get_upgrade_count(upgrade.id)
	
	var is_maxed = quantity >= upgrade.max_quantity
	
	progress_bar.value = percent if not is_maxed else 1
	purchase_button.disabled = percent < 1 || is_maxed
	progress_label.text = str(currency) + " / " + str(upgrade.experience_cost) if not is_maxed else ""
	count_label.text = "x%d" % quantity if not is_maxed else "Max"


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func on_purchase_pressed():
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	
	get_tree().call_group("meta_upgrade_card", "update_progress")
