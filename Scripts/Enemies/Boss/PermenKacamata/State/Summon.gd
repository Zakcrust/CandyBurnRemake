extends Node

var grenade : PackedScene
var fsm: StateMachine

var chacha : PackedScene = load("res://Scenes/Enemies/ChaCha.tscn")

var summon_distance : float = 300

signal activate()

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()


func enter() -> void:
	print("Current state : %s" % self.name)
	if fsm.obj.summon_counts <= 10:
		summon()
		yield(get_tree().create_timer(3.0), "timeout")
		yield(self, "activate")
	next("Move")

func summon():
	var angle : float
	var current_position : Vector2
	for i in range(0, 10):
		angle = deg2rad(360.0 * ((i + 1)/10.0))
		print("angle position : %s" % angle)
		var cha_cha_instance = chacha.instance()
		connect("activate", cha_cha_instance, "start")
		cha_cha_instance.connect("death_sign", fsm.obj, "decrease_summon_count")
		cha_cha_instance.global_position = fsm.obj.global_position
		$Tween.interpolate_property(cha_cha_instance, "position", cha_cha_instance.global_position, 
		rotated_point(cha_cha_instance.global_position, angle, summon_distance), 0.5)
		fsm.obj.get_parent().add_child(cha_cha_instance)
		fsm.obj.summon_counts += 1
		$Tween.start()
		yield($Tween, "tween_completed")
	emit_signal("activate")

func rotated_point(_center, _angle, _distance) -> Vector2:
		return _center + Vector2(sin(_angle),cos(_angle)) * _distance

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
