class_name SpeedController
extends PWInterface

@onready var control : Node3D = $"speed control/Cube_001"

func _ready():
	input_type = Player.InputType.ONEDIM_WS
	value = 0.0
	incremenet = 0.1
	multiplayer.peer_connected.connect(on_peer_connected)

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

func on_peer_connected(id : int):
	if multiplayer.is_server():
		reflect_speed_controller_value.rpc_id(id, value)

@rpc("authority", "call_remote", "reliable")
func reflect_speed_controller_value(val : float):
	value = val
	control.rotation.z = val
