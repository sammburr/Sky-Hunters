class_name SteamControl
extends StaticBody3D


@onready var lever : Node3D = $steam_control/Lever


var value : float


func animate(val : float):
	lever.rotation.x = val
	value = val
