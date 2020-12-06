extends Node

class_name Item

var ITEM_NAME : String
var ITEM_EFFECT : String
var POWER : int


func _init(item_name = "", item_effect = "", power = 0):
	ITEM_NAME = item_name
	ITEM_EFFECT = item_effect
	POWER = power
	

func get_item_name() -> String:
	return ITEM_NAME

func get_item_effect() -> String:
	return ITEM_EFFECT

func get_item_power() -> int:
	return POWER

