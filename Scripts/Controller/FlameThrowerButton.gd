extends TextureButton


signal fire_flame()
signal stop_flame()

var charged : bool = false

func _ready():
	disabled = true


func _on_Shoot_toggled(button_pressed):
	if button_pressed:
		emit_signal("fire_flame")
	else:
		emit_signal("stop_flame")


func _on_Player_set_energy_ui(value, max_value):
	$Progress.value = 0
	$Progress.max_value = max_value


func _on_Player_update_energy_ui(amount):
	$Progress.value = amount
	if $Progress.value >= $Progress.max_value and not charged:
		charged = true
		disabled = false
	if $Progress.value <= 0 and charged:
		charged = false
		disabled = true
		pressed = false
		emit_signal("stop_flame")
