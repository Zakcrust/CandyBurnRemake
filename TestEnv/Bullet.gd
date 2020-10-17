extends Projectile

var bullet_speed : int = 400 setget set_speed, get_speed

var bullet_stats : ProjectileStats = ProjectileStats.new(400,1)
var bullet_damage : int = 0

func _ready():
	bullet_speed = bullet_stats.speed
	bullet_damage = bullet_stats.damage

func _process(delta):
	position += transform.x * bullet_speed * delta

func set_speed(value) -> void:
	bullet_speed = value

func get_speed() -> int:
	return bullet_speed


func _on_Bullet_area_entered(area):
	if area is Dummy:
		queue_free()
	elif area is Enemy:
		if area.dead:
			return
		area.health = area.health - bullet_damage
		queue_free()
