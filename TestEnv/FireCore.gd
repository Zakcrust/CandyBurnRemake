extends Particles2D


var default_pos : Vector2 = Vector2(0, -10)
var default_scale : Vector2 = Vector2(1,1)

var fire_damage : int = 2

func _ready():
	$FlameHitBox/Collider.disabled = true


func _on_FlameHitBox_body_entered(body):
	if body is Enemy:
		if not body.get_dead():
			body.health = body.health - fire_damage


func _on_FlameHitBox_area_entered(area):
	if area is Enemy:
		if not area.get_dead():
			area.health = area.health - fire_damage

func start_flame() -> void:
	$FlameHitBox/Collider.disabled = false
	emitting = true
	$HitBoxAnim.play("flame_on")


func stop_flame() -> void:
	$FlameHitBox/Collider.disabled = true
	emitting = false
	$FlameHitBox/Collider.scale = default_scale
	$FlameHitBox/Collider.position = default_pos
	if $HitBoxAnim.is_playing():
		$HitBoxAnim.seek(0)
	$HitBoxAnim.stop()
	
