class_name Blimp
extends StaticBody3D


@onready var master : Master = get_node("/root/Master")


@export var helm_control : VehicalControl
@export var steam_control : VehicalControl
@export var air_control : VehicalControl


func _process(delta):
	var state = PackedByteArray([0,0,0,0,0,0,0,0,0,0,0])
	
	var force = Vector3(0, air_control.value * delta, 0) + (transform.basis * Vector3(0,0,-steam_control.value * delta))
	position += force
	rotate_y(helm_control.value * 0.1)
	
	Logger.log(transform.basis * Vector3(0,0,-1.0))
	
	state.encode_s8(0, helm_control.value)
	state.encode_s8(1, steam_control.value)
	state.encode_s8(2, air_control.value)
	
	state.encode_half(3, position.x)
	state.encode_half(5, position.y)
	state.encode_half(7, position.z)
	state.encode_half(9, rotation.y)

	master.network_manager.update_blimp.rpc(state)
