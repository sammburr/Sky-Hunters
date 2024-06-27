class_name LocalPlayer
extends CharacterBody3D


@export var sens : float = 0.015
@export var mouse_smooth : float = 0.5
@export var weapon_socket : Node3D
@export var local_arms : LocalArms


@onready var master : Master = get_node("/root/Master")

@onready var head : Node3D = $Head
@onready var ground_check : RayCast3D = $GroundCheck
@onready var interaction_check : RayCast3D = $Head/RayCast3D


var has_mouse_moved : bool = false
var stuck_to : Node3D
var stuck_to_last_pos : Vector3


func move_player(pos : Vector3, _head_rot : float, _player_rot : float):
	
	var discresion = global_position.distance_to(pos)
	if discresion < 0.01:
		global_position = pos
	
	global_position = lerp(global_position, pos, discresion)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		
		head.rotation.x = lerp(head.rotation.x, head.rotation.x - event.relative.y * sens, mouse_smooth)
		rotation.y = lerp(rotation.y, rotation.y - event.relative.x * sens, mouse_smooth)
		
		has_mouse_moved = true

	else:
		if Input.is_action_just_pressed("interact"):
			master.network_manager.try_interact.rpc_id(1)

func _process(_delta):
	
	if ground_check.is_colliding():
		var collider = ground_check.get_collider()
		if collider is Blimp:
			reparent(collider)
	
	var input_map = [
		Input.is_action_pressed("move_forward"),
		Input.is_action_pressed("move_back"),
		Input.is_action_pressed("move_left"),
		Input.is_action_pressed("move_right"),
	]
	
	var has_an_input = false
	for val in input_map:
		if val:
			has_an_input = true
	
	var direction = Vector3()
	
	if has_an_input || has_mouse_moved:
		var packed_input_map = Helpers.pack_b8(input_map)
		var packed_byte_map = PackedByteArray([packed_input_map, 0, 0, 0, 0])
		packed_byte_map.encode_half(1, head.rotation.x)
		packed_byte_map.encode_half(3, rotation.y)

		direction = Vector3(
			int(input_map[1]) - int(input_map[0]),
			0.0,
			int(input_map[3]) - int(input_map[2])
		)

		master.network_manager.set_player_input_map.rpc_id(1, packed_byte_map)
		has_mouse_moved = false

	predict_movement(direction)

	if interaction_check.is_colliding():
		var collision = interaction_check.get_collider()
		if collision is SteamControl || collision is AirControl || collision is HelmControl:
			master.ui_manager.show_tool_tip("Press E to use")
	else:
		master.ui_manager.close_tool_tip()


func predict_movement(direction : Vector3):
	var player_settings : Dictionary = master.player_manager.get_local_player_settings()
	
	if !is_on_floor():
		velocity.y -= 9.81 * get_process_delta_time()
	else:
		velocity = lerp(velocity, Vector3.ZERO, 0.2)
		
	
	if player_settings.is_empty():
		return
	
	var speed = player_settings["speed"]
	
	direction = (global_transform.basis.inverse() * direction).normalized()
	
	velocity.x = direction.z * speed
	velocity.z = direction.x * speed

	move_and_slide()
