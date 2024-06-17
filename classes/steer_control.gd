class_name SteerController
extends PWInterface

@onready var control : Node3D = $"steer_control/Cube_001"

var local_up : Vector3

func _ready():
	input_type = Player.InputType.ONEDIM_AD
	value = 0.0
	incremenet = 0.1 
	multiplayer.peer_connected.connect(on_peer_connected)
	
	local_up = control.transform.basis.y.normalized()

func increase_value():
	value += incremenet
	control.rotate(local_up , incremenet)
	
	if multiplayer.is_server():
		reflect_steer_controller_value.rpc(value)

func decrease_value():
	value -= incremenet
	control.rotate(local_up , -incremenet)
	
	if multiplayer.is_server():
		reflect_steer_controller_value.rpc(value)

func on_peer_connected(id : int):
	if multiplayer.is_server():
		reflect_steer_controller_value.rpc_id(id, value)

@rpc("authority", "call_remote", "reliable")
func reflect_steer_controller_value(val : float):
	var diff = val - value
	value = val
	control.rotate(local_up , diff)
