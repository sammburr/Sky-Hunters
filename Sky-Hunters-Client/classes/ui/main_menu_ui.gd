class_name MainMenuUI
extends Control


@onready var master : Master = get_node("/root/Master")

@onready var ip_text_field : TextEdit = $MarginContainer/VBoxContainer/HBoxContainer/Ip
@onready var port_text_field : TextEdit = $MarginContainer/VBoxContainer/HBoxContainer/Port
@onready var name_text_field : TextEdit = $MarginContainer/VBoxContainer/Name

var connection_info_box : InfoUIPopUp


func _on_join_pressed():
	Logger.log("join pressed")

	if connection_info_box:
		connection_info_box.queue_free()
	
	var ip : String = ip_text_field.text
	var port : String = port_text_field.text
	var player_name : String = name_text_field.text
	
	if ip.is_valid_ip_address() && port.is_valid_int():
		
		master.network_manager.connect_to_server(ip, int(port), player_name)
		
		var info = "Connecting to " + ip + ":" + port + "..."
		connection_info_box = InfoUIPopUp.create_info_popup(info)
		
		add_child(connection_info_box)


func _on_quit_pressed():
	Logger.log("quit pressed")
	
	# Instance popup
	add_child(ConfirmQuitUIPopUp.create_popup())
