extends Node2D

var current_weapon = PlayerWeapons.FLAME_PISTOL

var current_bullet = load("res://Scenes/Projectile/Bullet.tscn")
onready var initial_position = $Sprite.position

func shoot(target : KinematicBody2D) -> void:
	var bullet_instance = current_bullet.instance()
	bullet_instance.rotation = global_rotation
	bullet_instance.global_position = $GunPoint.global_position
	get_parent().get_parent().get_parent().add_child(bullet_instance)

func gun_shoot_anim() -> void:
	print("bam")
	var target_position = initial_position + Vector2(sin(get_parent().rotation), cos(get_parent().rotation)) * -20
	$Tween.interpolate_property($Sprite, "position", initial_position, target_position, 0.4, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.3), "timeout")
	shoot(get_parent().get_parent().target)

func stop_all_tweens() -> void:
	$Tween.stop_all()
