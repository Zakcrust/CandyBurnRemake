extends Character

enum {
	MOVE
	SHOOT
	IDLE
}

var enemies : Array

var current_stats : BaseStats = BaseStats.new()
var current_behaviour : BehaviourStats = BehaviourStats.new()
var current_status : String = CharacterStatus.ALIVE
var current_inventory : CharacterInventory = CharacterInventory.new()
var animation_state = "parameters/state/current"
var move_direction : Vector2
var knockback_direction : Vector2
var knockback_duration : float
var knockback_speed : float

var flame_scene = load("res://TestEnv/FireCore.tscn")

onready var flame = $Body/Hand/GunPoint/Flame


signal set_health_ui(value, max_value)
signal set_energy_ui(value, max_value)

signal update_coins_ui(value)

signal update_health_ui(amount)
signal update_energy_ui(amount)

# WARNING : use self.current_weapon to assign/retrieve current_weapon in order to trigger the setget methods
# May look another way to prevent null data assigned accidentally
var player_weapons : PlayerWeapons = PlayerWeapons.new()
var current_weapon : WeaponStats = player_weapons.get_weapon(PlayerWeapons.FLAME_PISTOL) setget set_weapon, get_weapon

var target : KinematicBody2D





func _ready():
	## DEBUG - May be replaced later
	current_inventory.add_item(player_weapons.get_weapon(PlayerWeapons.FLAME_PISTOL))
	current_inventory.add_item(player_weapons.get_weapon(PlayerWeapons.FLAMETHROWER))
	
	self.current_weapon = current_inventory.get_weapon(PlayerWeapons.FLAME_PISTOL)
	#################################################################################
	
	
	GlobalInstance.player = self
	refresh_enemy_pool()

	emit_signal("set_health_ui", current_stats.health, character_stats.health)
	emit_signal("set_energy_ui", current_stats.energy, character_stats.energy)

#	$NativeDrawDebug.update()

func set_weapon(weapon : WeaponStats) -> void:
	if weapon == null:
		return
	current_weapon = weapon
	$Body/Hand/Sprite.texture = load(current_weapon.sprite_path)

func get_weapon() -> WeaponStats:
	return current_weapon

# LIST OF DATA INPUT
# - TYPE OF CHARACTER (CharacterTypes Constants)
# - Basic Stats :
#		Health (int), Energy(int), Armour (int), Speed (int), Attack damage (int),
# - Behaviour Stats :
#		Attack radius (float), Detect radius (float)

func _init().(CharacterTypes.PLAYER, BaseStats.new(20,100,0,200,0, BehaviourStats.new(300, 400))):
	current_stats.health = character_stats.health
	current_stats.armour = character_stats.armour
	current_stats.speed = character_stats.speed
	current_stats.energy = 0

	current_behaviour.attack_radius = character_stats.behaviour_stats.attack_radius
	current_behaviour.detect_radius = character_stats.behaviour_stats.detect_radius

func gun_move() -> void:
	$Body/Hand/AnimationTree.set(animation_state, MOVE)

func gun_idle() -> void:
	$Body/Hand/AnimationTree.set(animation_state, IDLE)

func shoot() -> void:
	if target != null:
		match current_weapon.weapon_id:
			PlayerWeapons.FLAME_PISTOL:
				$Body/Hand/AnimationTree.set(animation_state, SHOOT)


func fire_flame() -> void:
	self.current_weapon = current_inventory.get_weapon(PlayerWeapons.FLAMETHROWER)
	flame.fire_damage = current_weapon.damage
	flame.start_flame()
	
#	flame = flame_scene.instance()
#	flame.fire_damage = current_weapon.damage
##	flame.global_rotation = $Body/Hand.global_rotation
#	flame.position = $Body/Hand/GunPoint.global_position
#	$Body/Hand.add_child(flame)


func stop_flame() -> void:
	flame.stop_flame()
	self.current_weapon = current_inventory.get_weapon(PlayerWeapons.FLAME_PISTOL)


func knockback(object, duration : float, speed : float) -> void:
	knockback_direction =  -(object.global_position - global_position).normalized()
	knockback_duration = duration
	knockback_speed = speed
	$StateMachine.change_to("Hit")

func hit(damage : float) -> void:
	var damage_dealt : float = (damage - current_stats.armour) if (damage - current_stats.armour) > 0 else 0
	current_stats.health = current_stats.health - damage_dealt
	emit_signal("update_health_ui", current_stats.health)
	if current_stats.health <= 0:
		die()


func die() -> void:
	$Body.play("dead")
	$Body/Hand.hide()
	$StateMachine.change_to("Dead")
	current_status = CharacterStatus.DEAD


func refresh_enemy_pool() -> void:
	enemies = GlobalInstance.enemies


func _on_Joystick_send_output(direction):
	move_direction = direction


func set_anim(anim_id :int) -> void:
	$Body/Hand/AnimationTree.set(animation_state, anim_id)


func fill_energy(amount : float) -> void:
	if current_weapon.weapon_id == PlayerWeapons.FLAMETHROWER:
		return
	current_stats.energy += (amount * 5)
	print("Player's energy : %s" % current_stats.energy)
	if current_stats.energy > character_stats.energy:
		current_stats.energy = character_stats.energy
	emit_signal("update_energy_ui", current_stats.energy)


func fill_health(amount : int) -> void:
	current_stats.health += amount
	if current_stats.health > character_stats.health:
		current_stats.health = character_stats.health
	emit_signal("update_health_ui", current_stats.health)


func reduce_energy(amount : float) -> void:
	current_stats.energy -= amount
	if current_stats.energy < 0:
		current_stats.energy = 0
	emit_signal("update_energy_ui", current_stats.energy)


func _process(delta):
	if current_weapon.weapon_id == PlayerWeapons.FLAMETHROWER and current_stats.energy > 0:
		reduce_energy(current_weapon.energy_cost * delta)



func _on_Shoot_fire_flame():
	fire_flame()


func _on_Shoot_stop_flame():
	stop_flame()


func _on_NativeDrawDebug_draw():
#	$NativeDrawDebug.draw_circle($NativeDrawDebug.position, current_behaviour.detect_radius, Color8(0, 255,0, 75))
#	$NativeDrawDebug.draw_circle($NativeDrawDebug.position, current_behaviour.attack_radius, Color8(255,0,0, 100))
	pass


func add_coins(amount : int) -> void:
	current_inventory.add_coins(amount)
	emit_signal("update_coins_ui", current_inventory.coins)


func get_coins() -> int:
	return current_inventory.get_coins()


func take_coins(amount : int) -> void:
	current_inventory.take_coins(amount)
	emit_signal("update_coins_ui", current_inventory.coins)

