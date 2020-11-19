extends AudioStreamPlayer2D


func _ready():
	stream = load("res://Sounds/SFX/enemy_hit.wav")

func hit() -> void:
	play()
