extends Node

var object : Character
var grenade : PackedScene
var fsm: StateMachine

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()


func enter(obj : Character) -> void:
	object = obj
	print("Current state : %s" % self.name)
	dead()
	get_parent().sprite_node.animate("dead")

func dead():
	print("dead")

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
