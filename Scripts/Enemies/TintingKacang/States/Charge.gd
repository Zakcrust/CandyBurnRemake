extends Node

signal done()
signal target_reached()

var active : bool = false
var direction : Vector2 = Vector2()
var speed_multiplier : float = 6.0

var target_position : Vector2
var tolerance : Vector2 = Vector2(10,10)

var fsm: StateMachine

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()

func enter() -> void:
	fsm.obj.set_anim(fsm.obj.CHARGE)
	yield(self, "done")
	exit()


func charge() -> void:
	yield(get_tree().create_timer(0.2), "timeout")
	target_position = fsm.player.global_position
	direction = (target_position - fsm.obj.global_position).normalized()
	active = true
	yield(self, "target_reached")
	emit_signal("done")


func process(_delta):
	if active:
		fsm.obj.move_and_collide(direction * fsm.obj.current_stats.speed * speed_multiplier * _delta)
		if fsm.obj.global_position > (target_position - tolerance) and target_position < (target_position + tolerance):
			active = false
			emit_signal("target_reached")


func physics_process(_delta):
	pass

func input(_event):
	pass
