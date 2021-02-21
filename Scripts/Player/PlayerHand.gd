extends Node2D

var current_bullet = load("res://Scenes/Projectile/Bullet.tscn")
onready var initial_position = $Sprite.position

func shoot(target : KinematicBody2D) -> void:
	var bullet_instance = current_bullet.instance()
	bullet_instance.bullet_damage = get_parent().get_parent().current_weapon.damage
	bullet_instance.bullet_speed = get_parent().get_parent().current_weapon.bullet_speed
	bullet_instance.rotation = global_rotation
	bullet_instance.global_position = $GunPoint.global_position
	get_parent().get_parent().get_parent().add_child(bullet_instance)


func gun_shoot_anim() -> void:
	if out_of_range():
		return
	match get_parent().get_parent().current_weapon.weapon_id:
		PlayerWeapons.FLAME_PISTOL:
			var target_position = initial_position + Vector2(sin(get_parent().rotation), cos(get_parent().rotation)) * -40
			$Tween.interpolate_property($Sprite, "position", initial_position, target_position, 0.4, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
			$Tween.start()
			yield(get_tree().create_timer(0.3), "timeout")
			shoot(get_parent().get_parent().target)

func stop_all_tweens() -> void:
	$Tween.stop_all()


func out_of_range() -> bool:
	if get_parent().get_parent().target != null:
		return get_parent().get_parent().global_position.distance_to(get_parent().get_parent().target.global_position) > get_parent().get_parent().current_behaviour.attack_radius
	else:
		return true
