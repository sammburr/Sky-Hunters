class_name Player
extends CharacterBody3D


@onready var master : Master = get_node("/root/Master")

@onready var head : Node3D = $Head


var has_moved : bool = false


func _process(delta):
	if !is_on_floor():
		velocity.y -= 9.81 * delta
		has_moved = true
		move_and_slide()

func move_player(input_map : PackedByteArray):
	
	var player_settings = master.player_manager.get_player_settings(name.to_int())
	if player_settings.is_empty():
		return
	
	var speed = player_settings["speed"]
	
	var unpacked_input_map : Array = Helpers.unpack_b8(input_map[0])
	
	var input_map_head_rot : float = input_map.decode_half(1)
	var input_map_player_rot : float = input_map.decode_half(3)
	
	head.rotation.x = input_map_head_rot
	rotation.y = input_map_player_rot
	
	var move_forward = int(unpacked_input_map[0])
	var move_back = int(unpacked_input_map[1])
	var move_left = int(unpacked_input_map[2])
	var move_right = int(unpacked_input_map[3])

	var direction = Vector3(
		move_back - move_forward,
		0.0,
		move_right - move_left
	)
	direction = (transform.basis.inverse() * direction).normalized()
	
	velocity.x = direction.z * speed
	velocity.z = direction.x * speed

	move_and_slide()
	has_moved = true
