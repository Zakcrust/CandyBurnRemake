extends Character

signal send_bullet(obj)

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

var summon_counts : int = 0

func _init().(CharacterTypes.BOSS, BaseStats.new(100,0,100,5, BehaviourStats.new(0, 1000))):
	load_stats()

func _ready():
	GlobalInstance.add_enemy(self)


# THIS FUNCTION MUST BE RUN (AT LEAST) ONCE
func load_stats() -> void:
	current_stats.health = character_stats.health
	current_stats.armour = character_stats.armour
	current_stats.speed = character_stats.speed
	current_stats.attack = character_stats.attack
	
	current_behaviour_stats.attack_radius = character_stats.behaviour_stats.attack_radius
	current_behaviour_stats.detect_radius = character_stats.behaviour_stats.detect_radius


func hit(damage : float) -> void:
	var damage_dealt = (damage - current_stats.armour) if (damage - current_stats.armour) > 0 else 0
	current_stats.health = current_stats.health - damage_dealt
	
	if current_stats.health <= 0:
		dead()
		
	## May insert some functions to do another actions


func decrease_summon_count() -> void:
	summon_counts -= 1

func dead() -> void:
	$StateMachine.change_to("Dead")
	current_status = CharacterStatus.DEAD
