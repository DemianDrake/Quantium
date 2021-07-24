extends Spatial

export (Array, String) var dialogue

func button_pressed(_mode):
	get_tree().call_group("Player", "temporal_gravitometer", 3)
	get_tree().call_group("Player", "comment", dialogue)
