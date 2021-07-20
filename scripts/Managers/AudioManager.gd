extends Node

var song  = [
	preload("res://music/Shimmering_Nebulae.wav"),
	preload("res://music/Calm_before_Chaos.wav"),
	preload("res://music/Bandwidth_Bandits.wav"),
	preload("res://music/Monsters_at_the_Core.wav")
]

var sfx = {
	'click': preload("res://sfx/kenney_interfacesounds/switch_006.ogg")
}

var current_song = 0

func play():
	return song[current_song]

func next():
	current_song = (current_song + 1) % song.size()
	return song[current_song]

func seek(index: int):
	current_song = index
	return song[current_song]

func get_sfx(name):
	return sfx[name]
