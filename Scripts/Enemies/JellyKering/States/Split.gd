extends Node

var fsm: StateMachine

var mini_jelly_kering : PackedScene = load("res://Scenes/Enemies/JellyKeringMini.tscn")

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()

func enter() -> void:
	for i in range (0,2):
		var mini_jelly = mini_jelly_kering.instance()
		mini_jelly.global_position = fsm.obj.global_position
		mini_jelly.global_position += (Vector2.ONE * (randi() % 50 - 50))
		fsm.obj.get_parent().add_child(mini_jelly)

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
