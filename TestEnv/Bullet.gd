extends Node2D


var speed : int = 400


func _process(delta):
	position += transform.x * speed * delta
