extends Character

enum {
	MOVE
	SHOOT
	IDLE
}



var stats : BaseStats = BaseStats.new()

var animation_state = "parameters/state/current"
var move_direction : Vector2
var knockback_direction : Vector2
var knockback_duration : float
var knockback_speed : float

func _ready():
	GlobalInstance.player = self

func _init().(CharacterTypes.PLAYER, BaseStats.new(1000,0,200)):
	stats.health = character_stats.health
	stats.armour = character_stats.armour
	stats.speed = character_stats.speed

func gun_move() -> void:
	$Body/Hand/AnimationTree.set(animation_state, MOVE)

func gun_idle() -> void:
	$Body/Hand/AnimationTree.set(animation_state, IDLE)

func shoot() -> void:
	$Body/Hand/AnimationTree.set(animation_state, SHOOT)

func knockback(object, duration : float, speed : float) -> void:
	knockback_direction =  -(object.global_position - global_position).normalized()
	knockback_duration = duration
	knockback_speed = speed
	$StateMachine.change_to("Hit")

func hurt(damage : float) -> void:
	var damage_dealt : float = (damage - stats.armour) if (damage - stats.armour) > 0 else 0
	stats.health = stats.health - damage_dealt
	if stats.health <= 0:
		die()

func die() -> void:
	$Body.play("dead")
	$Body/Hand.hide()
	$StateMachine.change_to("Dead")


func _on_Joystick_send_output(direction):
	move_direction = direction
	print("Move Direction : %s" % move_direction)


func _on_HurtBox_area_entered(area):
	var hitbox_parent = area.get_parent()
	if area.get_parent() is Enemy:
		if area.get_parent().dead:
			return
	if area is Enemy or area is EnemyProjectile:
		knockback_direction = area.position.direction_to(position)
		hurt(2.0)
		knockback(area, 0.2, 600)
		area.queue_free()


func _on_HurtBox_body_entered(body):
	if body is Enemy:
		if body.dead:
			return
		hurt(2.0)
		knockback(body, 0.2, 600)
	elif body is EnemyProjectile:
		hurt(2.0)
		knockback(body, 0.2, 600)
