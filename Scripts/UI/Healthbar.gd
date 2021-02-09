extends TextureProgress


func _on_Player_set_health_ui(value, max_value):
	self.value = value
	self.max_value = max_value


func _on_Player_update_health_ui(amount):
	value = amount
