class_name HelmControl
extends StaticBody3D


@onready var wheel : Node3D = $helm_control/Wheel


func animate(value : float):
	wheel.rotation.z = value
