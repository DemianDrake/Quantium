extends Tween

onready var target = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.interpolate_property(target, "color", Color(255,255,255,255), Color(255,0,255,0), 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	self.interpolate_property(target, "percent_visible", 1, 0, 5, Tween.TRANS_LINEAR)
	self.start()
	print('Debería comenzar?')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
