class_name SteamControl
extends StaticBody3D


@onready var lever : Node3D = $steam_control/Lever


func animate(value : float):
	lever.rotation.x = value
