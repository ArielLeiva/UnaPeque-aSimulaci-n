extends Timer

var button_id: int = -1
@onready var st = get_parent()

func change(id):
	match id:
		0:
			glob.new_mass += 100
			get_tree().get_first_node_in_group("mass_counter").text = str(glob.new_mass)
		1:
			if	(glob.new_mass > glob.min_mass):
				glob.new_mass -= 100
				get_tree().get_first_node_in_group("mass_counter").text = str(glob.new_mass)
		2:
			glob.new_vol += 0.1
			get_tree().get_first_node_in_group("previsualization").update_scale()
		3:
			if (glob.new_vol > glob.min_vol):
				glob.new_vol -= 0.1
				get_tree().get_first_node_in_group("previsualization").update_scale()

func _ready():
	change(button_id)	
	pass

func _on_timeout():
	
	if !st.conds[button_id]:
		queue_free()
	else:
		change(button_id)
