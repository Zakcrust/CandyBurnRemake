extends Node2D

var flame_start : AudioStream = load("res://Sounds/SFX/flamehrower_start.wav")
var flame_mid : AudioStream = load("res://Sounds/SFX/flamehrower_mid.wav")
var flame_end : AudioStream = load("res://Sounds/SFX/flamehrower_end.wav")


func start_flame() -> void:
	if $Sfx.playing:
		return
	$Sfx.stream = flame_start
	$Sfx.play()

func stop_flame() -> void:
	if $Sfx.playing:
		$Sfx.stop()
	$Sfx.stream = flame_end
	$Sfx.play()

func adjust_volume(value) -> void:
	$Sfx.volume_db = value

func _on_Sfx_finished():
	if $Sfx.stream == flame_start:
		$Sfx.stream = flame_mid
		$Sfx.play()
