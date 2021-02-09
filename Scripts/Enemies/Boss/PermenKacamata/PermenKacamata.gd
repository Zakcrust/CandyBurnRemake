extends Character

enum {
	MOVE,
	DEAD
}


signal send_bullet(obj)
signal set_healtbar_ui(value, max_value)
signal update_healthbar_ui(value)


signal death_sign(obj)

# LIST OF DATA INPUT
# - TYPE OF CHARACTER (CharacterTypes Constants)
# - Basic Stats :
#		Health (int), Energy (int),  Armour (int), Speed (int), Damage (int)
# - Behaviour Stats :
#		Attack radius (float), Detect Radius (float)

# THESE VARIABLE SHOULD BE INITIALIZED

var current_stats : BaseStats = BaseStats.new()
var current_behaviour_stats : BehaviourStats = BehaviourStats.new()
var current_status : String = CharacterStatus.ALIVE

var summon_counts : int = 0

var animator_params : String = "parameters/state/current"

func _init().(CharacterTypes.BOSS, BaseStats.new(100,0,0,100,5, BehaviourStats.new(0, 1000))):
	load_stats()

func _ready():
	GlobalInstance.add_enemy(self)
	current_status = CharacterStatus.INVUNERABLE
	emit_signal("set_healtbar_ui", current_stats.health, character_stats.health)
	yield($CanvasLayer/HealthUI, "done")
	current_status = CharacterStatus.ALIVE
	


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
	
	emit_signal("update_healthbar_ui", current_stats.health)
	
	if current_stats.health <= 0:
		dead()
		
	## May insert some functions to do another actions

func set_anim(anim_id : int) -> void:
	$Animator.set(animator_params, anim_id)


func decrease_summon_count() -> void:
	summon_counts -= 1

func dead() -> void:
	$State.change_to("Dead")
	current_status = CharacterStatus.DEAD
	emit_signal("death_sign", self)


func _on_HitBox_area_entered(area):
	var body = area.get_parent()
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(current_stats.attack)
				body.knockback(self, 0.5, 300)


func _on_HitBox_body_entered(body):
	if body is Character:
		if body.character_type == CharacterTypes.PLAYER:
			if body.current_status == CharacterStatus.ALIVE:
				body.hit(current_stats.attack)
				body.knockback(self, 0.5, 300)
