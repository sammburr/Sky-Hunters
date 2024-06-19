class_name PauseUI
extends Control


@onready var master : Master = get_node("/root/Master")


func _on_button_pressed():
	master.network_manager.disconnect_from_server()
