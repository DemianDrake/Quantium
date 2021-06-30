extends "res://scripts/Item.gd"


export var hp_amount = 30

func _ready():
	pass 

func interact(body: Node):
	if body.is_in_group('Player'):
		body.add_hp(hp_amount)
		body.holding_item = false
		queue_free()

