extends Area2D

var enemies : Array

signal send_enemies(ens)

#func _process(delta):
#	set_monitoring(true)
#	yield(get_tree().create_timer(.5),"timeout")
#	set_monitoring(false)
	



func _on_EnemyDetector_area_entered(area):
	if area is Dummy:
		for enemy in enemies:
			if enemy == area:
				return
		enemies.append(area)
	elif area is Enemy:
		for enemy in enemies:
			if enemy == area:
				return
		enemies.append(area)
	emit_signal("send_enemies", enemies)
	


func _on_EnemyDetector_body_entered(body):
	if body is Dummy:
		for enemy in enemies:
			if enemy == body:
				return
		enemies.append(body)
	elif body is Enemy:
		for enemy in enemies:
			if enemy == body:
				return
		enemies.append(body)
	emit_signal("send_enemies", enemies)
