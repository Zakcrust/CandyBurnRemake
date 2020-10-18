extends Node2D

export (int) var max_running_instance = 2
export (int) var spawn_radius = 0
var rand : RandomNumberGenerator

func _ready():
	randomize()
	rand = RandomNumberGenerator.new()
	rand.randomize()
	$Timer.start()

var enemies = [
	load("res://TestEnv/JellyArcher.tscn"),
	load("res://TestEnv/JellyKering.tscn"),
	load("res://TestEnv/JellyTombak.tscn")
]

func spawn() -> void:
	enemies.shuffle()
	var enemy_to_spawn = enemies.front()
	var enemy_instance = enemy_to_spawn.instance()
	enemy_instance.global_position.x = global_position.x + rand.randi_range(-spawn_radius, spawn_radius)
	enemy_instance.global_position.y = global_position.y + rand.randi_range(-spawn_radius, spawn_radius)
	add_child(enemy_instance)
	

func get_running_instance() -> int:
	return get_child_count() - 1


func _on_Timer_timeout():
	if get_running_instance() < max_running_instance:
		spawn()
