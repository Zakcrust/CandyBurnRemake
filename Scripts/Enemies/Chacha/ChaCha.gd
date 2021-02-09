extends Character


enum {
	MOVE,
	DEAD
}

signal death_sign(obj)

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

var animator_params : String = "parameters/State/current"

func _ready():
	GlobalInstance.add_enemy(self)

func _init().(CharacterTypes.ENEMY, BaseStats.new(10,0,0,150,2, BehaviourStats.new(0, 1000))):
	load_stats()

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
		

func set_anim(anim_id : int) -> void:
	$Animator.set(animator_params, anim_id)


func dead() -> void:
	$StateMachine.change_to("Dead")
	emit_signal("dead")


func start() -> void:
	if $StateMachine.state.name == "Move":
		$StateMachine.state.start_pathfinding()


func _on_HitBox_body_entered(body):
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(current_stats.attack)
				body.knockback(self, 0.5, 300)


func _on_HitBox_area_entered(area):
	var body = area.get_parent()
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(current_stats.attack)
				body.knockback(self, 0.5, 300)
