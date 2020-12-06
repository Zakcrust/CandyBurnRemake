extends Node2D

var spawner_state : SpawnerState = SpawnerState.new()

var current_wave_count : int = 1

var maximum_wave : int = 9

var registered_spawner : Array
var registered_spawner_state : Array

signal win()
signal add_flame_power(amount)
signal wave_ui(current_wave)

func _ready():
	emit_signal("wave_ui", current_wave_count)
	$PotionSpawners._spawn_potions()


func set_current_wave(value) -> void:
	current_wave_count = value

func get_current_wave() -> int:
	return current_wave_count

func register_spawner(spawner : Node2D, state : SpawnerState) -> void:
	registered_spawner.append(spawner)
	registered_spawner_state.append(state)
	print(registered_spawner)
	print(registered_spawner_state)

func check_spawners() -> void:
	for _state in registered_spawner_state:
		if _state.current_state == spawner_state.DEFAULT:
			return
	yield(get_tree().create_timer(1.0),"timeout")
	next_wave()

func done_spawn(state : SpawnerState) -> void:
	var id = registered_spawner_state.find(state)
	registered_spawner_state[id].current_state = state.CLEARED
	check_spawners()

func reset_spawners() -> void:
	for child in get_children():
		if child is Enemy:
			if child.get_dead():
				child.queue_free()
	for _state in registered_spawner_state:
		_state.current_state = spawner_state.DEFAULT
	for spawner in registered_spawner:
		spawner.reinit_spawner()

func next_wave() -> void:
	if current_wave_count < maximum_wave:
		current_wave_count += 1
		print("current wave : %s" % current_wave_count)
		reset_spawners()
		$PotionSpawners._spawn_potions()
		emit_signal("wave_ui", current_wave_count)
	else:
		print("you win")
		emit_signal("win")
		pause_mode = PAUSE_MODE_STOP
		get_tree().paused = true
