class_name Blimp
extends StaticBody3D


@export var helm_control : HelmControl
@export var steam_control : SteamControl
@export var air_control : AirControl


func update_blimp(state : PackedByteArray):
	
	var helm_value = state.decode_s8(0)
	var steam_value = state.decode_s8(1)
	var air_value = state.decode_s8(2)
	
	helm_control.animate(helm_value * 0.1)
	steam_control.animate(steam_value * 0.1)
	air_control.animate(air_value)

	var pos =  Vector3(
		state.decode_half(3),
		state.decode_half(5),
		state.decode_half(7)
	)
	
	var discresion = position.distance_to(pos)
	position = lerp(position, pos, discresion)

	predict_movement()

func predict_movement():
	var force = Vector3(0, air_control.value * get_process_delta_time(), 0)
	position += force
