class_name LocalPlayer
extends CharacterBody3D

@export var speed = 200
@export var sens = 1

var player_manager : PlayerManager
var server_position : Vector3 # Position as broadcast by server

@onready var head = $Head

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_x(-event.relative.y * get_process_delta_time() * sens)
		rotate_y(-event.relative.x * get_process_delta_time() * sens)

func _physics_process(delta):

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if not is_on_floor():
		velocity.y -= 9.81 * delta
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if not multiplayer.is_server():
		# Send input to server for verification
		player_manager.send_input_direction.rpc_id(1, input_dir)
		player_manager.send_rotation.rpc_id(1, rotation, head.rotation)
		
		# Lerp towards server position
		position = lerp(position, server_position, 0.5)
		print(position.distance_to(server_position))

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x
	velocity.z = direction.z

	velocity.z = lerp(velocity.z, 0.0, 0.5)
	velocity.x = lerp(velocity.x, 0.0, 0.5)
	
	move_and_slide()
