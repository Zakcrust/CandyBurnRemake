extends Node

class_name CharacterType

var character_type : String setget , get_character_type

var PLAYER : String = "PLAYER" setget , get_player_type
var ENEMY : String = "ENEMY"	setget , get_enemy_type

func _init(type = ""):
	character_type = type

func get_character_type() -> String:
	return character_type

func get_player_type() -> String:
	return PLAYER

func get_enemy_type() -> String:
	return ENEMY
