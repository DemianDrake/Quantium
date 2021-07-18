extends Node

var song  = [
	preload("res://music/Shimmering_Nebulae.wav")
]

var current_song = 0

func play():
	return song[current_song]

func next():
	current_song = (current_song + 1) % song.size()
	return song[current_song]
