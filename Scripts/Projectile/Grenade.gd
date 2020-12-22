extends Node2D

var explosion_scene : PackedScene = load("res://Scenes/Explosion/Explosion.tscn")

func throw_to(pos : Vector2) -> void:
	$Tween.interpolate_property(self, "position",position, pos, 1.0, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	yield(get_tree().create_timer(1.0), "timeout")
	$Sprite.hide()
	var explosion : Node2D = explosion_scene.instance()
	add_child(explosion)
	explosion.scale *= 4
	yield(explosion, "tree_exited")
	queue_free()
