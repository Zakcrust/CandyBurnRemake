extends Sprite

signal send_button_pos(pos)
signal send_shoot()
signal end_flame_thrower()

var flame_thrower_available = load("res://Assets/Main Character/flametrower_anim.tres")
var flame_thrower_empty = load("res://Assets/Main Character/walk/fire4.png")

var filling_bar = load("res://Assets/PNG/HealthBar/barHorizontal_yellow.png")
var filled_bar = load("res://Assets/PNG/HealthBar/barHorizontal_green.png")
var flamethrower_ready : bool = false

func _ready():
	global_position.x = 1080/2
#	$Shoot.normal = flame_thrower_empty
#	$Shoot.modulate = Color(1.0,1.0,1.0,0.5)

func get_pos() -> Vector2:
	return $GamePad.get_button_pos()

func _on_GamePad_forward_button_pos(pos):
	emit_signal("send_button_pos", pos)


func _on_Shoot_pressed():
	if $Timer.is_stopped():
		$Timer.start()
	emit_signal("send_shoot")


func _on_Timer_timeout():
	GlobalInstance.player.energy = GlobalInstance.player.energy - 1
	print(GlobalInstance.player.energy)
	if $FlameThrowerBar.value <=0:
		$Timer.stop()
		emit_signal("end_flame_thrower")
#		$Shoot.normal = flame_thrower_empty
#		$Shoot.modulate = Color(1.0,1.0,1.0,0.5)
#		$Shoot.pressed = flame_thrower_empty
		flamethrower_ready = false


func _on_SpawnerPool_add_flame_power(amount):
	if flamethrower_ready:
		return
	if $FlameThrowerBar.value == $FlameThrowerBar.max_value:
		flamethrower_ready = true
		return
	$FlameThrowerBar.value += amount


func _on_FlameThrowerBar_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if flamethrower_ready:
				flamethrower_ready = false
				if $Timer.is_stopped():
					$Timer.start()
				emit_signal("send_shoot")
				


func _on_Player_set_energy_max_ui(value):
	$FlameThrowerBar.max_value = value


func _on_Player_set_energy_bar_ui(value):
	if $FlameThrowerBar.value == $FlameThrowerBar.max_value and not flamethrower_ready:
		flamethrower_ready = true
		return
	$FlameThrowerBar.value = value
