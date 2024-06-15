class_name SpeedController
extends PWInterface

var value : float = 0.0
var incremenet : float = 0.1

@onready var control : Node3D = $"speed control/Cube_001"

func increase_value():
	value += incremenet
	control.rotate_z(incremenet)
	
	if multiplayer.is_server():
		reflect_speed_controller_value.rpc(value)

func decrease_value():
	value -= incremenet
	control.rotate_z(-incremenet)
	
	if multiplayer.is_server():
		reflect_speed_controller_value.rpc(value)

@rpc("authority", "call_remote", "reliable")
func reflect_speed_controller_value(val : float):
	value = val
	control.rotation.z = val
