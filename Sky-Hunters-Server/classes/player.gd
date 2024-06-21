class_name Player
extends CharacterBody3D


@onready var master : Master = get_node("/root/Master")

@onready var head : Node3D = $Head
@onready var ray_cast : RayCast3D = $Head/RayCast3D
@onready var ground_check : RayCast3D = $GroundCheck

var has_moved : bool = false
var control_target : VehicalControl = null

var stuck_to : Node3D = null
var stuck_to_last_pos : Vector3

func _process(delta):
	
	if ground_check.is_colliding():
		var collider = ground_check.get_collider()
		if collider is Blimp:
			stuck_to = collider
			stuck_to_last_pos = stuck_to.position
	
	if stuck_to:
		Logger.log(stuck_to.position - stuck_to_last_pos)
		position += stuck_to.position - stuck_to_last_pos
		stuck_to_last_pos = stuck_to.position
	
	if !is_on_floor():
		velocity.y -= 9.81 * delta
	else:
		velocity = lerp(velocity, Vector3.ZERO, 0.2)
	
	has_moved = true
	move_and_slide()

func move_player(input_map : PackedByteArray):
	
	# Ignore movement if the player is using a vehical control
	# just send the player's input map over to it.
	if control_target:
		control_target.read_input(input_map)
		return
	
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


func try_interact():
	
	# If the player interacts whilst using a control
	# make the player leave the control
	if control_target:
		control_target = null
		return
	
	if ray_cast.is_colliding():
		var collision = ray_cast.get_collider()
		if collision is VehicalControl:
			control_target = collision
			position = collision.stand_target.global_position
