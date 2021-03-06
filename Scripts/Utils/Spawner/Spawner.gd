extends Node2D

export (int) var max_running_instance = 2
export (int) var spawn_radius = 0
export (int) var spawner_id = -1

var rand : RandomNumberGenerator
var spawn_data : Resource = SpawnerData.new()
var spawn_state = SpawnerState.new()

var wave : Wave

var enemy_type : String
var running_instance : int = 0
var maximum_spawn : int
var spawn_count : int = 0

var chosen_enemy

var enemies = [
	load("res://Scenes/Enemies/GulaGait.tscn"),
	load("res://Scenes/Enemies/JellyKeringNew.tscn"),
	load("res://Scenes/Enemies/TintingKacang.tscn"),
	load("res://Scenes/Enemies/PermenKacamata.tscn")
]

func _ready():
	init_spawner()

func init_spawner() -> void:
	if spawner_id == -1:
		return
	
	wave =  spawn_data.get_wave_by_id(get_parent().current_wave_count, spawner_id)
	enemy_type = wave.enemy_to_spawn
	maximum_spawn = wave.spawn_count
	
	if maximum_spawn <= 0:
		spawn_state.current_state = spawn_state.CLEARED
		get_parent().register_spawner(self, spawn_state)
		return
	elif maximum_spawn > 1:
		maximum_spawn += 1
		get_parent().register_spawner(self, spawn_state)
	
	randomize()
	rand = RandomNumberGenerator.new()
	rand.randomize()
	choose_enemy()
	$Timer.start()

func reinit_spawner():
	spawn_count = 0
	running_instance = 0
	
	wave =  spawn_data.get_wave_by_id(get_parent().current_wave_count, spawner_id)
	enemy_type = wave.enemy_to_spawn
	maximum_spawn = wave.spawn_count
	
	if maximum_spawn <= 0:
		spawn_state.current_state = spawn_state.CLEARED
		return
	else:
		spawn_state.current_state = spawn_state.DEFAULT
	
	randomize()
	rand = RandomNumberGenerator.new()
	rand.randomize()
	choose_enemy()
	$Timer.start()

func choose_enemy() -> void:
	match(enemy_type):
		SpawnerData.GULA_GAIT:
			chosen_enemy = enemies[0]
		SpawnerData.JELLY_KERING:
			chosen_enemy = enemies[1]
		SpawnerData.TINTING_KACANG:
			chosen_enemy = enemies[2]
		SpawnerData.PERMEN_KACAMATA:
			chosen_enemy = enemies[3]


func spawn() -> void:
	if running_instance < max_running_instance and spawn_count <= maximum_spawn:
		var enemy_instance = chosen_enemy.instance()
		enemy_instance.connect("death_sign", self , "kill_notifier")
		enemy_instance.position.x = global_position.x + rand.randi_range(-spawn_radius, spawn_radius)
		enemy_instance.position.y = global_position.y + rand.randi_range(-spawn_radius, spawn_radius)
		get_parent().add_child(enemy_instance)
		running_instance += 1
		add_spawn_count()
		
		
func add_spawn_count() -> void:
	spawn_count += 1
	if spawn_count >= maximum_spawn and running_instance == 0:
		get_parent().done_spawn(spawn_state)
	check_spawn_state()


func check_spawn_state() -> void:
	match(spawn_state.current_state):
		spawn_state.DEFAULT:
			pass
		spawn_state.CLEARED:
			$Timer.stop()


func get_running_instance() -> int:
	return running_instance


func kill_notifier(obj) -> void:
#	if GlobalInstance.player.weapon_state != GlobalInstance.player.FLAMETHROWER:
#		GlobalInstance.player.energy = GlobalInstance.player.energy + 10
	## TODO : REIMPLEMENT FLAMETHROWER
#	var current_coin = GlobalInstance.player.coin
#	GlobalInstance.player.coin = current_coin + 1
	## TODO : REIMPELEMENT COIN
	#get_parent().emit_signal("add_flame_power", 10)
	running_instance -= 1
	if maximum_spawn == 1 and spawn_count >= maximum_spawn:
		get_parent().done_spawn(spawn_state)
	if spawn_count >= maximum_spawn and running_instance == 0:
		get_parent().done_spawn(spawn_state)


func _on_Timer_timeout():
	if get_running_instance() < max_running_instance:
		spawn()
