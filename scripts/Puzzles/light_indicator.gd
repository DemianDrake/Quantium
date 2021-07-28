extends StaticBody

onready var mesh : MeshInstance = $MeshInstance
onready var material : SpatialMaterial = mesh.mesh.material
onready var albedo : Color = material.albedo_color

const COLORS = [Color("#000000"), Color("#00b429")] # Negro, Verde

export var state : int = 0

var locked = false


func set_color():
	albedo = COLORS[state]
	material.albedo_color = albedo


func _ready() -> void:
	set_color()


func button_pressed(solved):
	if not locked and not solved:
		state = 1 - state
		set_color()
	elif not locked and solved:
		locked = true
