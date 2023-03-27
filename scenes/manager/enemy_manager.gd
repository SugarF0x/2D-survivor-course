extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position(anchor: Vector2):
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = Vector2.ZERO
	
	for i in 4:
		spawn_position = anchor + random_direction * SPAWN_RADIUS
		
		var query_parameters = PhysicsRayQueryParameters2D.create(anchor, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty(): break
		else: random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func spawn_enemy():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null: return
	
	var enemy_scene = enemy_table.pick_item() as PackedScene
	var enemy_instance = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group('entities_layer') as Node2D
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position(player.global_position)


func on_timer_timeout():
	timer.start()
	spawn_enemy()


func on_arena_difficulty_increased(arena_difficulty: int):
	timer.wait_time = max(base_spawn_time - (.1 / 12) * arena_difficulty, .3)
	
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)
