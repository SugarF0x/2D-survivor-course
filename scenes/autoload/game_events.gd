extends Node

signal experience_vial_collected(number: int)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_hit(damage: int, current_health: int)


func emit_experience_vial_collected(number: int):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_hit(damage: int, current_health: int):
	player_hit.emit(damage, current_health)
