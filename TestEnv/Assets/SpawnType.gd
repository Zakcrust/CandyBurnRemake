extends Node

class_name SpawnType

var instance_spawn : int = 0 setget , get_instance_amount

func _init(instance_amount = 0):
	instance_spawn = instance_amount
	pass

func get_instance_amount() -> int:
	return instance_spawn


class mobs:
	extends SpawnType
	func _init(instance_amount = 5):
		._init(instance_amount)
		

class defender:
	extends SpawnType
	func _init(instance_amount = 1):
		._init(instance_amount)
	


class ranger:
	extends SpawnType
	func _init(instance_amount = 1):
		._init(instance_amount)
