extends KinematicBody2D


var speed : int = 300

var velocity : Vector2

func _process(delta):
#	velocity = Vector2()
#	if Input.is_action_pressed("move_up"):
#		velocity += Vector2.UP
#	if Input.is_action_pressed("move_down"):
#		velocity += Vector2.DOWN
#	if Input.is_action_pressed("move_left"):
#		velocity += Vector2.LEFT
#	if Input.is_action_pressed("move_right"):
#		velocity += Vector2.RIGHT
#	velocity = velocity.normalized()
#	if velocity == Vector2():
#		$Sprite.play("idle")
#	else:
#		$Sprite.play("move")
#	look_at(position + (velocity * speed))
#	move_and_collide(velocity * speed * delta)
	_move_by_controller(delta)

func _look_at_mouse() -> void:
	look_at(get_global_mouse_position())

func _move_by_controller(delta):
	look_at(position + (velocity * speed))
	if velocity == Vector2():
		$Sprite.play("idle")
	else:
		$Sprite.play("move")
	move_and_collide(velocity * speed * delta)


func _on_Controller_send_button_pos(pos):
	velocity = pos
	
