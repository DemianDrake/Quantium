extends "res://scripts/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	item_name = 'Long Box'
	max_amount = 1
	scene_path = 'res://scenes/assets/props/box1.tscn'
	texture_path = 'res://addons/item_textures/box1.png'

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
