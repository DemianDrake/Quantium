extends Control

func _ready():
	var _error = Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	if len(Input.get_connected_joypads()) > 0:
		$ColorRect/MarginContainer/GridContainer/Slot1/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot1/TextureRect/JSLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot2/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot2/TextureRect/JSLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot3/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot3/TextureRect/JSLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot4/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot4/TextureRect/JSLabel.show()

func update_hotbar(inventory):
	var slot
	var slot_node
	var text
	var texture
	
	for key in inventory.keys():
		slot = inventory[key]
		slot_node = get_node("ColorRect/MarginContainer/GridContainer/"+key)
		if slot['item_name'] != 'empty':
			text = str(slot['amount']) + '/' + str(slot['max_amount'])
			texture = ImageTexture.new()
			texture.create_from_image(load(slot['texture_path']))
			
			slot_node.get_node("TextureRect/Amount").set_text(text)
			slot_node.get_node('TextureRect').set_texture(texture)
		else:
			slot_node.get_node("TextureRect/Amount").set_text('')
			slot_node.get_node('TextureRect').set_texture(null)

func _on_joy_connection_changed(_device_id, connected):
	if connected:
		$ColorRect/MarginContainer/GridContainer/Slot1/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot1/TextureRect/JSLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot2/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot2/TextureRect/JSLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot3/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot3/TextureRect/JSLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot4/TextureRect/KBLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot4/TextureRect/JSLabel.show()
	else:
		$ColorRect/MarginContainer/GridContainer/Slot1/TextureRect/KBLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot1/TextureRect/JSLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot2/TextureRect/KBLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot2/TextureRect/JSLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot3/TextureRect/KBLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot3/TextureRect/JSLabel.hide()
		$ColorRect/MarginContainer/GridContainer/Slot4/TextureRect/KBLabel.show()
		$ColorRect/MarginContainer/GridContainer/Slot4/TextureRect/JSLabel.hide()
