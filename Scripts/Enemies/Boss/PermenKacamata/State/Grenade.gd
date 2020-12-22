extends Node

var object : KinematicBody2D

var grenade : PackedScene = load("res://Scenes/Projectile/Grenade.tscn")

var fsm: StateMachine

func next(next_state):
	get_tree()
	fsm.change_to(next_state)

func exit():
	fsm.back()


func enter(obj : KinematicBody2D) -> void:
	object = obj
	print("Current state : %s" % self.name)
	throw_grenade()
	get_parent().sprite_node.animate("throw_grenade")
	

func throw_grenade():
	var grenade_instance = grenade.instance()
	grenade_instance.position = object.global_position
	add_child(grenade_instance)
	grenade_instance.throw_to(get_parent().player.global_position)
	
	yield(grenade_instance, "tree_exited")
	next("Move")

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
