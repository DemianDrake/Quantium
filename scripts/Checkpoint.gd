extends Area


func _ready() -> void:
	var _entered_signal = connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node):
	if body.is_in_group("Player"):
		LevelManager.checkpoint = self

func on():
	$CollisionShape.set_deferred("disabled", true)
	print("%s is on" % name)

func off():
	$CollisionShape.set_deferred("disabled", false)
	print("%s is off" % name)

func get_spawn_point():
	return $Spawn.global_transform.origin
