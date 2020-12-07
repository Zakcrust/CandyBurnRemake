extends Node

var player : Player setget set_player, get_player
var enemies : Array setget , get_enemies
var coin : int = 0 setget set_coin , get_coin




func set_player(value : Player):
	player = value

func get_player() -> Player:
	return player

func add_enemy(value : Enemy):
	enemies.append(value)
	player.refresh_enemy_pool()

func remove_enemy(value : Enemy):
	enemies.erase(value)
	player.refresh_enemy_pool()

func get_enemies() -> Array:
	return enemies

func set_coin(value : int) -> void:
	coin = value

func get_coin() -> int:
	return coin
