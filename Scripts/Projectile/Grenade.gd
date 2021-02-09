extends Node2D

var explosion_scene : PackedScene = load("res://Scenes/Explosion/Explosion.tscn")

var grenade_damage : float = 5.0

func _ready():
	$HitBox/Collider.disabled = true

func throw_to(pos : Vector2) -> void:
	$Tween.interpolate_property(self, "position",position, pos, 1.0, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	yield(get_tree().create_timer(1.0), "timeout")
	$Sprite.hide()
	var explosion : Node2D = explosion_scene.instance()
	add_child(explosion)
	$HitBox/Collider.call_deferred("set_disabled", false)
	explosion.scale *= 4
	yield(explosion, "tree_exited")
	queue_free()


func _on_HitBox_area_entered(area):
	var body = area.get_parent()
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(grenade_damage)
				body.knockback(self, 0.5, 300)


func _on_HitBox_body_entered(body):
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(grenade_damage)
				body.knockback(self, 0.5, 300)
