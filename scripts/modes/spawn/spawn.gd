extends Node2D

var ball = preload("res://scenes/balls.tscn")
var stage = null
var camera = null
var ui = null
var enabled: bool = false
var click_held: bool = false
var clicked_pos = Vector2.ZERO
var global_clicked_pos = Vector2.ZERO
var arrow = null
# Inicial velocity vector
var init_vector = Vector2.ZERO

func deactivate():
	visible = false
	click_held = false
	set_process(false)
	set_physics_process(false)

func spawn_ball(position, mass, volume, init_vel, rot_vel, selected):
	var x = ball.instantiate()
	x.position = position
	x.mass = mass
	x.proportion = volume
	x.linear_velocity = init_vel
	x.angular_velocity = rot_vel
	stage.add_child(x)
	x.add_to_group("balls")
	if selected:
		x.add_to_group("selected")
		x.modulate = Color(0.5,0.7,0.7)
	return x

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled = true
	camera = get_tree().get_first_node_in_group("camera")
	ui = get_tree().get_first_node_in_group("UI")
	stage = get_tree().get_first_node_in_group("stage")
	arrow = get_node("arrow")
	deactivate()

func _input(event):
	if enabled and event.is_action_pressed("spawn"):
		clicked_pos = event.position
		global_clicked_pos = camera.camera_to_global(clicked_pos)
		
		if !ui.inside_ui(clicked_pos) and camera.inside_camera(clicked_pos) and camera.inside_container(global_clicked_pos):
			click_held = true
			arrow.position = global_clicked_pos
			visible = true
			set_process(true)
			set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("r_click"):
		deactivate()
	# Ball initial velocity setting
	elif click_held:
		if Input.is_action_pressed("l_click"):
			var present_click = get_viewport().get_mouse_position()
			init_vector = present_click - clicked_pos
			arrow.look_and_scale(init_vector / camera.zoom.x)
		elif Input.is_action_just_released("l_click"):
			spawn_ball(global_clicked_pos, glob.new_mass, glob.new_vol, init_vector / camera.zoom.x, 0, false)
			# Hide arrow and stop processing
			deactivate()

func _on_stage_mode_updated():
	enabled = glob.mode == glob.states.SPAWN_MODE
