extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_hotbar(inventory):
	var slot
	var slot_node
	var text
	var texture
	var image
	
	for key in inventory.keys():
		slot = inventory[key]
		slot_node = get_node("ColorRect/MarginContainer/GridContainer/"+key)
		if slot['item_name'] != 'empty':
			text = str(slot['amount']) + '/' + str(slot['max_amount'])
			texture = ImageTexture.new()
			image = Image.new()
			image.load(slot['texture_path'])
			image.resize(60, 60)
			texture.create_from_image(image)
			
			slot_node.get_node("TextureRect/Amount").set_text(text)
			slot_node.get_node('TextureRect').set_texture(texture)
		else:
			slot_node.get_node("TextureRect/Amount").set_text('')
			slot_node.get_node('TextureRect').set_texture(null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
