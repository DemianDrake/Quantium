extends "res://scripts/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	item_name = 'Box'
	max_amount = 5
	scene_path = 'res://scenes/assets/props/box2.tscn'
	texture_path = 'res://addons/item_textures/box2.png'

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
