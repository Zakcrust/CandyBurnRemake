extends Node


var sfx_volume : int = 0 setget set_sfx, get_sfx
var music_volume : int = 0 setget set_music, get_music

func set_sfx(value) -> void:
	sfx_volume = value
	
func get_sfx() -> int:
	return sfx_volume
	
func set_music(value) -> void:
	music_volume = value

func get_music() -> int:
	return music_volume
