extends Particles2D


var default_pos : Vector2 = Vector2(0, -10)
var default_scale : Vector2 = Vector2(1,1)

var fire_damage : int = 2 setget set_damage, get_damage

func set_damage(damage : int) -> void:
	fire_damage = damage

func get_damage() -> int:
	return fire_damage


func _ready():
	$FlameHitBox/Collider.disabled = true
	$CPUMobileRender.convert_from_particles($".")


func _on_FlameHitBox_body_entered(body):
	if body is Enemy:
		if not body.get_dead():
			body.health = body.health - fire_damage


func _on_FlameHitBox_area_entered(area):
	var enemy = area.get_parent()
	if enemy is Character:
		match enemy.character_type:
			CharacterTypes.ENEMY:
				if enemy.current_status == CharacterStatus.ALIVE:
					enemy.hit(fire_damage)
			CharacterTypes.BOSS:
				if enemy.current_status == CharacterStatus.ALIVE:
					enemy.hit(fire_damage)

func start_flame() -> void:
	$FlameHitBox/Collider.disabled = false
	$CPUMobileRender.emitting = true
	$HitBoxAnim.play("flame_on")
	$FlameSound.start_flame()

func stop_flame() -> void:
	$FlameHitBox/Collider.disabled = true
	$CPUMobileRender.emitting = false
	$HitBoxAnim.seek(0.0)
	$HitBoxAnim.stop()
	$FlameSound.stop_flame()
