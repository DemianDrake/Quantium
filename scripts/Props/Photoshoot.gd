extends Viewport

export var folder = "res://addons/item_textures/photoshoot/"
var objects = []

func _ready() -> void:
	for child in get_parent().get_node("Objects").get_children():
		objects.append(child)
		child.visible = false
	
	yield(get_tree().create_timer(1), "timeout")
	for object in objects:
		save_photo(object)
		yield(get_tree().create_timer(1), "timeout")

func save_photo(object):
	object.visible = true
	var path = folder + object.name + ".png"
	yield(get_tree().create_timer(0.5), "timeout")
	var img = get_texture().get_data()
	img.convert(Image.FORMAT_RGBA8)
	img.flip_y()
	img.save_png(path)
	yield(get_tree().create_timer(0.5), "timeout")
	object.visible = false
	print("saved to ", path)
