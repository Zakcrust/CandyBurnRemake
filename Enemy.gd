extends KinematicBody2D

class_name Enemy

var type : CharacterType = EnemyCharacter.new() setget , get_type
var character_stats : MobStats = MobStats.new(1,1,0)


func get_type() -> CharacterType:
	return type
