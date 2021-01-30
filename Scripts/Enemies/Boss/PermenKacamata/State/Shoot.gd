extends Node

var bullet : PackedScene = load("res://Scenes/Projectile/BossBullet.tscn")
var fsm: StateMachine

var shoot_wave : int = 3
var current_shoot_wave : int = 0

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()


func enter() -> void:
	print("Current state : %s" % self.name)
	shoot()

func shoot():
	current_shoot_wave += 1
	var pattern : Array = eight_direction_shoot()
	for obj in pattern:
		fsm.obj.emit_signal("send_bullet", obj)
	$ShootTimer.start()

func eight_direction_shoot() -> Array:
	var bullet_pattern = [
		instance_bullet(Vector2.LEFT),
		instance_bullet(Vector2.RIGHT),
		instance_bullet(Vector2.UP),
		instance_bullet(Vector2.DOWN),
		instance_bullet(Vector2.LEFT + Vector2.UP),
		instance_bullet(Vector2.LEFT + Vector2.DOWN),
		instance_bullet(Vector2.RIGHT + Vector2.UP),
		instance_bullet(Vector2.RIGHT + Vector2.DOWN),
	]
	return bullet_pattern


func instance_bullet(direction : Vector2) -> Node2D:
	var bullet_instance = bullet.instance()
	bullet_instance.position = fsm.obj.global_position
	bullet_instance.direction = direction
	return bullet_instance

func shoot_done():
	next("move")

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass


func _on_ShootTimer_timeout():
	if current_shoot_wave < shoot_wave:
		shoot()
	else:
		current_shoot_wave = 0
		$ShootTimer.stop()
		next("Move")
