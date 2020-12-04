extends Node

var player : Player setget set_player, get_player

func set_player(value : Player):
	player = value

func get_player() -> Player:
	return player
