extends Character


enum  {
	MOVE,
	CHARGE,
	DEAD
}

# LIST OF DATA INPUT
# - TYPE OF CHARACTER (CharacterTypes Constants)
# - Basic Stats :
#		Health (int), Armour (int), Speed (int), Damage (int)
# - Behaviour Stats :
#		Attack radius (float), Detect Radius (float)

# THESE VARIABLE SHOULD BE INITIALIZED

var current_stats : BaseStats = BaseStats.new()
var current_behaviour_stats : BehaviourStats = BehaviourStats.new()
var current_status : String = CharacterStatus.ALIVE

var animator_params : String = "parameters/States/current"
var minimum_wander_time : float = 3.0


onready var pointer = $Pointer

signal death_sign()


func _init().(CharacterTypes.ENEMY, BaseStats.new(10,0,75,2, BehaviourStats.new(600, 1000))):
	load_stats()

# THIS FUNCTION MUST BE RUN (AT LEAST) ONCE
func load_stats() -> void:
	current_stats.health = character_stats.health
	current_stats.armour = character_stats.armour
	current_stats.speed = character_stats.speed
	current_stats.attack = character_stats.attack
	
	current_behaviour_stats.attack_radius = character_stats.behaviour_stats.attack_radius
	current_behaviour_stats.detect_radius = character_stats.behaviour_stats.detect_radius

func _ready():
	GlobalInstance.add_enemy(self)

func hit(damage : float) -> void:
	var damage_dealt = (damage - current_stats.armour) if (damage - current_stats.armour) > 0 else 0
	current_stats.health = current_stats.health - damage_dealt
	
	if current_stats.health <= 0:
		dead()
		
	## May insert some functions to do another actions


func dead() -> void:
	$StateMachine.change_to("Dead")
	current_status = CharacterStatus.DEAD
	emit_signal("death_sign")


func set_anim(anim_id : int) -> void:
	$Animator.set(animator_params, anim_id)


func _on_Hitbox_area_entered(area):
	if current_status == CharacterStatus.DEAD:
		return
	var body = area.get_parent()
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(current_stats.attack)
				body.knockback(self, 0.5, 200)


func _on_Hitbox_body_entered(body):
	if current_status == CharacterStatus.DEAD:
		return
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(current_stats.attack)
				body.knockback(self, 0.5, 200)
