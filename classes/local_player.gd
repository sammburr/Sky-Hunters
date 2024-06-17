class_name LocalPlayer
extends Player

@export var sens = 1
@export var viewmodel_swing = 0.5

@onready var viewmodel : Node3D = $Head/VIEWMODEL

var player_manager : PlayerManager
var server_position : Vector2 # Position as broadcast by server
var origin_viewmodel : Vector3 # Start position of viewmodel

func _ready():
	origin_viewmodel = viewmodel.position

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_x(-event.relative.y * get_process_delta_time() * sens)
		rotate_y(-event.relative.x * get_process_delta_time() * sens)
		
		# Apply viewmodel swing
		viewmodel.position.y += event.relative.y * get_process_delta_time() * viewmodel_swing
		viewmodel.position.x += -event.relative.x * get_process_delta_time() * viewmodel_swing

func _physics_process(delta):

	apply_gravity()

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Jumping
	if Input.is_action_just_pressed("ui_accept") and is_grounded:
		player_jump()
	
	# Interacting
	if Input.is_action_just_pressed("interact"):
		interact()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	if not multiplayer.is_server():
		# TODO: make cleaner here...
		
		# Send input to server for verification
		var input_dirs = [input_dir.x, input_dir.y]
		if Input.is_action_just_pressed("ui_accept") and is_grounded:
			input_dirs.append(1.0)
		else:
			input_dirs.append(0.0)
		
		if Input.is_action_just_pressed("interact"):
			player_manager.try_interact.rpc_id(1)
		
		player_manager.send_input_direction.rpc_id(1, input_dirs)
		player_manager.send_rotation.rpc_id(1, rotation, head.rotation)
		
		# Lerp towards server position
		position.x = lerp(position.x, server_position.x, 0.05)
		position.z = lerp(position.z, server_position.y, 0.05)
		var flat_pos = Vector2(position.x, position.z)
		if flat_pos.distance_to(server_position) < 0.01:
			position.x = server_position.x
			position.z = server_position.y

	# Apply viewmodel swing acording to input_dir
	viewmodel.position.x -= input_dir.x * delta * viewmodel_swing * 4.0
	viewmodel.position.z -= input_dir.y * delta * viewmodel_swing * 4.0
	
	viewmodel.position = lerp(viewmodel.position, origin_viewmodel, 0.5)

	player_move(input_dir)

