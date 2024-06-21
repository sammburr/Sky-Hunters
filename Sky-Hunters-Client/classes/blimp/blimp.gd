class_name Blimp
extends StaticBody3D


@export var helm_control : HelmControl
@export var steam_control : SteamControl
@export var air_control : AirControl


func update_blimp(state : PackedByteArray):
	
	var helm_value = state.decode_s8(0)
	var steam_value = state.decode_s8(1)
	var air_value = state.decode_s8(2)
	
	helm_control.animate(helm_value)
	steam_control.animate(steam_value)
	air_control.animate(air_value)

	var pos =  Vector3(
		state.decode_half(3),
		state.decode_half(5),
		state.decode_half(7)
	)

	var rot_y = state.decode_half(9)

	var discresion = position.distance_to(pos)
	position = lerp(position, pos, discresion)
	rotation.y = rot_y

	predict_movement()

func predict_movement():
	var delta = get_process_delta_time()
	var force = Vector3(0, air_control.value * delta, 0) + (transform.basis * Vector3(0,0,-steam_control.value * delta))
	position += force
	rotate_y(helm_control.value * 0.1)
