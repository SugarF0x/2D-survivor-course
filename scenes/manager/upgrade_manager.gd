extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_move_speed = preload("res://resources/upgrades/player_speed.tres")


func _ready():
	experience_manager.level_up.connect(on_level_up)
	
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_move_speed, 5)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	
	for i in min(upgrade_pool.items.size(), 3):
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades) as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(upgrade: AbilityUpgrade):
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity >= upgrade.max_quantity: upgrade_pool.remove_item(upgrade)
	
	match (upgrade.id):
		upgrade_axe.id: upgrade_pool.add_item(upgrade_axe_damage, 10)


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	
	var available_upgrades = pick_upgrades()
	
	upgrade_screen_instance.set_ability_upgrades(available_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
