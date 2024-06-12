class_name UIManager
extends Node

@onready var network_manager : NetworkManager = $"../Network Manager"

@onready var server_button : Button = $"Server Button"
@onready var player_button : Button = $"Player Button"
@onready var disconnect_button : Button = $"Disconnect Button"

func _on_server_button_button_down():
	print("Starting as server...")
	network_manager.start_server()

func _on_player_button_button_down():
	print("Starting as player...")
	network_manager.start_player()

func _on_disconnect_button_button_down():
	print("Disconnecting...")
	network_manager.disconnect_peer()

func hide_startup_button(hide : bool):
	if hide:
		server_button.hide()
		player_button.hide()
		# But show disconnect
		disconnect_button.show()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		server_button.show()
		player_button.show()
		# But hide disconnect
		disconnect_button.hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	disconnect_button.hide()
	
