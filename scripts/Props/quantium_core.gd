extends MeshInstance

var nrg_flux = 0.05
var mat = null
var light = null

# Called when the node enters the scene tree for the first time.
func _ready():
	mat = mesh.surface_get_material(0)
	light = get_node("../OmniLight")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nrg = mat.get_emission_energy()
#	print(nrg)
	if nrg >= 10 or nrg <= 0:
#		print("energy flux change")
		nrg_flux *= -1
	mat.set_emission_energy(nrg + nrg_flux)
	light.omni_range = nrg + nrg_flux + 15
	pass
