extends Control

signal done()


func _on_PermenKacamata_set_healtbar_ui(value, max_value):
	$HBoxContainer/VBoxContainer/HealthBar.max_value = max_value
	var current_value : float = $HBoxContainer/VBoxContainer/HealthBar.value
	$Tween.interpolate_property($HBoxContainer/VBoxContainer/HealthBar, "value", current_value, value, 2.0)
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("done")


func _on_PermenKacamata_update_healthbar_ui(value):
	$HBoxContainer/VBoxContainer/HealthBar.value = value
