extends Node

var object : KinematicBody2D
var fsm: StateMachine
var path
var paths
var state_duration : float

func next(next_state):
	fsm.change_to(next_state)

func exit():
	fsm.back()

func enter(obj : KinematicBody2D) -> void:
	randomize()
	object = obj
	print("Current state : %s" % self.name)
	get_parent().sprite_node.animate("move")
	start_pathfinding()
	state_duration = randi() % 1 + 2
	$StateTimer.wait_time = state_duration
	$StateTimer.start()

func start_pathfinding():
	if get_parent().player != null:
		path_find()

func path_find() -> void:
	path = get_tree().get_root().get_node("Main/Navigation2D").get_simple_path(object.global_position, get_parent().player.position)
	if path != null:
		set_paths(path)

func set_paths(value : PoolVector2Array) -> void:
	paths = value
	paths.remove(0)

func move_along_path(distance : float) -> void:
	var last_point : = object.global_position
	for index in range(paths.size()):
		var distance_to_next = last_point.distance_to(paths[0])
		if distance <= distance_to_next and distance >= 0.0:
			object.global_position = last_point.linear_interpolate(paths[0], distance / distance_to_next)
			break
		elif paths.size() == 1 and distance >= distance_to_next:
			object.global_position = paths[0]
			if get_parent().player != null:
				path_find()
			else:
				get_parent().sprite.animate("idle")
			break

		distance -= distance_to_next
		last_point = paths[0]
		paths.remove(0)

func action(delta):
	var move_distance = object.SPEED * delta
	face_to(get_parent().player.position)
	move_along_path(move_distance)

func face_to(pos : Vector2) -> void:
	if object.global_position.x < pos.x:
		get_parent().sprite_node.scale.x = -abs(get_parent().sprite_node.scale.x)
	else:
		get_parent().sprite_node.scale.x = abs(get_parent().sprite_node.scale.x)

func process(_delta):
	path_find()
	action(_delta)

func physics_process(_delta):
	pass

func input(_event):
	pass

func unhandled_input(_event):
	pass

func unhandled_key_input(_event):
	pass

func notification(_what, _flag = false):
	pass

func _on_PathTimer_timeout():
	path_find()


func _on_StateTimer_timeout():
	var roll = randi() % 20 + 1
	if roll > 10:
		next("Shoot")
	else:
		next("Grenade")
