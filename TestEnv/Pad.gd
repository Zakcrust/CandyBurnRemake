extends Sprite

signal send_button_pos(pos)
signal send_shoot()

func get_pos() -> Vector2:
	return $GamePad.get_button_pos()


func _on_GamePad_forward_button_pos(pos):
	emit_signal("send_button_pos", pos)


func _on_Shoot_pressed():
	emit_signal("send_shoot")
