class_name Blimp
extends CharacterBody3D


@export var helm_control : HelmControl
@export var steam_control : SteamControl


func update_blimp(state : PackedByteArray):
	
	var helm_value = state.decode_s8(0)
	var steam_value = state.decode_s8(1)
	
	helm_control.animate(helm_value * 0.1)
	steam_control.animate(steam_value * 0.1)
