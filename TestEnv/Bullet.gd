extends Node2D

var speed : int = 400

func _process(delta):
	position += transform.x * speed * delta


func _on_Bullet_area_entered(area):
	if area is Dummy:
		queue_free()
	elif area is Enemy:
		queue_free()
