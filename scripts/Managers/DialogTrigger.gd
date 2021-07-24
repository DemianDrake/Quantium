extends Area

export var dialog_mode = "AUTO"
export var one_shot    = true
export (Array, String) var dialogues

export var activate_particles = false

onready var collision  = $CollisionShape

func _ready() -> void:
	var _error = connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Spatial):
	if body.is_in_group("Player"):
		if activate_particles:
			body.temporal_gravitometer(3)
		body.comment(dialogues, dialog_mode)
		collision.disabled = one_shot
