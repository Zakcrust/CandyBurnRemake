extends Node

var object : KinematicBody2D
var grenade : PackedScene
var fsm: StateMachine

func next(next_state):
	get_tree()
	fsm.change_to(next_state)

func exit():
	fsm.back()


func enter(obj : KinematicBody2D) -> void:
	object = obj
	print("Current state : %s" % self.name)
	stun()
	get_parent().sprite_node.animate("stun")
	yield(get_tree().create_timer(3.0), "timeout")
	exit()

func stun():
	print("Stunned")

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
