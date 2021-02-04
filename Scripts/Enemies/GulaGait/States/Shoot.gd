extends Node

var fsm: StateMachine

signal done()

var bullet : PackedScene = load("res://Scenes/Projectile/Bolt.tscn")
var rotation_to_player

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()

func enter() -> void:
	if fsm.obj.current_status == CharacterStatus.DEAD:
		next("Dead")
		return
	fsm.obj.shoot()
	yield(self, "done")
	exit()

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass

func shoot() -> void:
	var bullet_instance = bullet.instance()
	bullet_instance.global_position = fsm.obj.gun_point.global_position
#	rotation_to_player = GlobalInstance.player.global_position.angle_to_point(shoot_point.global_position) - deg2rad(90)
	fsm.obj.gun_point.look_at(GlobalInstance.player.global_position)
	rotation_to_player = fsm.obj.gun_point.global_rotation
	bullet_instance.rotation = rotation_to_player 
	fsm.obj.get_parent().add_child(bullet_instance)
	yield(get_tree().create_timer(3.0), "timeout")
	emit_signal("done")
	
