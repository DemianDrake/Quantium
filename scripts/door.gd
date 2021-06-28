extends KinematicBody


export var open = false
onready var opened_rotation = rotation_degrees - Vector3(0,90,0) # Abierta
onready var closed_rotation = rotation_degrees                   # Cerrada

func interact(body: Node):
	if open:
		$Tween.interpolate_property(self, "rotation_degrees", opened_rotation, closed_rotation, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property(self, "rotation_degrees", closed_rotation, opened_rotation, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	open = not open

func button_pressed(pressed):
	if open != pressed:
		interact(self)
