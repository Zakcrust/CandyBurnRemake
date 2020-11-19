extends Node2D


export (AudioStream) var sfx
export (AudioStream) var music
export (bool) var play_music_on_ready = false

func _ready():
	if play_music_on_ready and music != null:
		$Music.stream = music
		$Music.play()

func play_music() -> void:
	if $Music.playing:
		$Music.stop()
	$Music.stream = music
	$Music.play()


func play_sfx() -> void:
	if $Sfx.playing:
		$Sfx.stop()
	$Sfx.stream = sfx
	$Sfx.play()
