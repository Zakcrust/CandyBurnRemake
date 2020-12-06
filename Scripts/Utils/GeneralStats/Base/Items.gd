extends Node

class_name Items

var item_effects : ItemEffects = ItemEffects.new()

######################### LIST OF ITEM ######################
var HEALTH_BOOST : Item = Item.new("Health Boost", item_effects.HEAL, 2)
var ENERGY_BOOST : Item = Item.new("Enery Boost", item_effects.ENERGY, 10)
var HEALTH_PERCENTAGE_BOOST : Item = Item.new("Health Boost", item_effects.HEAL_PERCENTAGE, 0.5)

func get_health_boost() -> Item:
	return HEALTH_BOOST

func get_energy_boost() -> Item:
	return ENERGY_BOOST

func get_health_percentage_boost() -> Item:
	return HEALTH_PERCENTAGE_BOOST
