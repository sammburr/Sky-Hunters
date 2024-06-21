class_name AirControl
extends StaticBody3D


@onready var valve : Node3D = $air_control/Valve


var value : float


func animate(val : float):
	valve.rotation.z = val
	value = val
