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

var animation_state = "parameters/state/current"
var move_direction : Vector2
var knockback_direction : Vector2
var knockback_duration : float
var knockback_speed : float

var target : KinematicBody2D

func _ready():
	GlobalInstance.player = self
	refresh_enemy_pool()

# LIST OF DATA INPUT
# - TYPE OF CHARACTER (CharacterTypes Constants)
# - Basic Stats :
#		Health (int), Armour (int), Speed (int), Damage (int)
# - Behaviour Stats :
#		Attack radius (float), Detect Radius (float)

func _init().(CharacterTypes.PLAYER, BaseStats.new(1000,0,200,0, BehaviourStats.new(600, 1200))):
	current_stats.health = character_stats.health
	current_stats.armour = character_stats.armour
	current_stats.speed = character_stats.speed

	current_behaviour.attack_radius = character_stats.behaviour_stats.attack_radius
	current_behaviour.detect_radius = character_stats.behaviour_stats.detect_radius

func gun_move() -> void:
	$Body/Hand/AnimationTree.set(animation_state, MOVE)

func gun_idle() -> void:
	$Body/Hand/AnimationTree.set(animation_state, IDLE)

func shoot() -> void:
	if target != null:
		$Body/Hand/AnimationTree.set(animation_state, SHOOT)

func knockback(object, duration : float, speed : float) -> void:
	knockback_direction =  -(object.global_position - global_position).normalized()
	knockback_duration = duration
	knockback_speed = speed
	$StateMachine.change_to("Hit")

func hit(damage : float) -> void:
	var damage_dealt : float = (damage - current_stats.armour) if (damage - current_stats.armour) > 0 else 0
	current_stats.health = current_stats.health - damage_dealt
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
