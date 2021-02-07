extends Node

class_name ItemEvents

var item_effect : ItemEffects = ItemEffects.new()

func consume_item(item : Item) -> void:
	match(item.ITEM_EFFECT):
		item_effect.HEAL:
			var current_health = GlobalInstance.player.current_stats.health
			GlobalInstance.player.fill_health(item.POWER)
		item_effect.ENERGY:
			var current_energy = GlobalInstance.player.current_stats.energy
			GlobalInstance.player.fill_energy(item.POWER)
		item_effect.HEAL_PERCENTAGE:
			var current_health = GlobalInstance.player.current_stats.health
			var heal_power = GlobalInstance.player.current_stats.health * item.POWER
			GlobalInstance.player.fill_health(heal_power)
		
