extends Area2D

class_name DropItem

var item : Item setget , get_item

func _init(init_item = Items.new().HEALTH_BOOST):
	item = init_item

func get_item() -> Item:
	return item
