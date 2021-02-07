extends Node

var fsm: StateMachine

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()

func enter() -> void:
	fsm.obj.set_anim(fsm.obj.DEAD)
	fsm.obj.current_status = CharacterStatus.DEAD
	var energy : float = fsm.obj.character_stats.health
	fsm.player.fill_energy(energy)
	fsm.player.add_coins(fsm.obj.current_inventory.coins)

func process(_delta):
	pass

func physics_process(_delta):
	pass

func input(_event):
	pass
