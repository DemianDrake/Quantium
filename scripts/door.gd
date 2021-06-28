extends KinematicBody


export var open = false
var locked = false
onready var opened_rotation = rotation_degrees - Vector3(0,90,0) # Abierta
onready var closed_rotation = rotation_degrees                   # Cerrada

func _ready() -> void:
	if open:
		anim_open()

func interact(body: Node):
	if open:
		anim_close()
	else:
		anim_open()
	open = not open

func anim_open():
	$Tween.interpolate_property(self, "rotation_degrees", closed_rotation, opened_rotation, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()

func anim_close():
	$Tween.interpolate_property(self, "rotation_degrees", opened_rotation, closed_rotation, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	
func button_pressed(should_lock):
	if not locked:
		interact(self)
	locked = locked or should_lock
