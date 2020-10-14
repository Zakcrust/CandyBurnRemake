extends Area2D


var speed : int = 300


func _process(delta):
	position += transform.x * speed * delta

func _on_Bolt_body_entered(body):
	if body is Player:
		queue_free()
