extends Node

class_name ItemEvents

var item_effect : ItemEffects = ItemEffects.new()

func consume_item(item : Item) -> void:
	match(item.ITEM_EFFECT):
		item_effect.HEAL:
			var current_health = GlobalInstance.player.health
			GlobalInstance.player.health = current_health + item.POWER
		item_effect.ENERGY:
			pass
		item_effect.HEAL_PERCENTAGE:
			var current_health = GlobalInstance.player.health
			var heal_power = GlobalInstance.player.player_stats.health * item.POWER
			GlobalInstance.player.health = current_health + heal_power
		
