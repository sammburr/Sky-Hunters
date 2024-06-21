class_name HelmControl
extends StaticBody3D


@onready var wheel : Node3D = $helm_control/Wheel


var value : float


func animate(val : float):
	wheel.rotation.z = val * 30.0
	value = val
