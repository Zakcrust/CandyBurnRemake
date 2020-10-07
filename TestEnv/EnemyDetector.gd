extends Area2D

var enemies : Array

signal send_enemies(ens)


func _on_EnemyDetector_area_entered(area):
	if area is Dummy:
		for enemy in enemies:
			if enemy == area:
				return
		enemies.append(area)
		emit_signal("send_enemies", enemies)
		print(enemies)
