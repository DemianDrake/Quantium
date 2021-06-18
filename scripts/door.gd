extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var open = false
onready var opened_rotation = rotation_degrees - Vector3(0,90,0) # Abierta
onready var closed_rotation = rotation_degrees                   # Cerrada
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.

func interact():
	if open:
		$Tween.interpolate_property(self, "rotation_degrees", opened_rotation, closed_rotation, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property(self, "rotation_degrees", closed_rotation, opened_rotation, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	open = not open

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
