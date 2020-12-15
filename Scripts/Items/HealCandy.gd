extends DropItem

var item_events : ItemEvents = ItemEvents.new()

func _init().(Items.new().HEALTH_BOOST):
	pass

func _on_HealCandy_body_entered(body):
	if body is Player:
		item_events.consume_item(item)
		queue_free()
