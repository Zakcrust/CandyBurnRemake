extends Node2D

var jelly_kering_pool : Array
var gula_gait_pool : Array
var tingting_kacang_pool : Array


var jelly_kering : PackedScene = load("res://Scenes/Enemies/JellyKering.tscn")
var gula_gait : PackedScene = load("res://Scenes/Enemies/JellyArcher.tscn")
var tingting_kacang : PackedScene = load("res://Scenes/Enemies/JellyTombak.tscn")

export (int) var instance_amount = 100

func _ready():
	for i in range(0, instance_amount):
		spawn_and_hide(jelly_kering_pool, jelly_kering.instance())
		spawn_and_hide(gula_gait_pool, gula_gait.instance())
		spawn_and_hide(tingting_kacang_pool, tingting_kacang.instance())


func spawn_and_hide(pool : Array , instance) -> void:
	pool.append(instance)
	add_child(pool.back())
	pool.back().set_process(false)
	pool.back().hide()

func get_object_and_spawn(object_code : String, pos : Vector2) -> void:
	var object_to_spawn : Node2D
	match(object_code):
		EnemyCode.GULA_GAIT:
			object_to_spawn = gula_gait_pool.pop_back()
			object_to_spawn.global_position = pos
			object_to_spawn.show()
		EnemyCode.JELLY_KERING:
			object_to_spawn = jelly_kering_pool.pop_back()
			object_to_spawn.global_position = pos
			object_to_spawn.show()
		EnemyCode.TINTING_KACANG:
			object_to_spawn = tingting_kacang_pool.pop_back()
			object_to_spawn.global_position = pos
			object_to_spawn.show()
