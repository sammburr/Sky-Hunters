# AUTOLOADED 'UIManager'


extends Node


@onready var master : Master = get_node("/root/Master")

const main_menu_ui_scene = preload("res://scenes/ui/main_menu_ui.tscn")
const pause_menu_ui_scene = preload("res://scenes/ui/pause_ui.tscn")

var main_menu_ui : MainMenuUI
var pause_menu_ui : PauseUI
var player_list : InfoUIPopUp


# Create and attach an instance of the main menu UI
func open_main_menu():
	Logger.log("Opening Main Menu")
	close_pause_menu()
	close_player_list()
	main_menu_ui = main_menu_ui_scene.instantiate()
	add_child(main_menu_ui)


# Remove main menu UI from the scene
func close_main_menu():
	Logger.log("Closing Main Menu")
	if main_menu_ui:
		main_menu_ui.queue_free()
	main_menu_ui = null


func open_pause_menu():
	Logger.log("Opening Pause Menu")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause_menu_ui = pause_menu_ui_scene.instantiate()
	add_child(pause_menu_ui)


func close_pause_menu():
	Logger.log("Closing Pause Menu")
	if not multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if pause_menu_ui:
		pause_menu_ui.queue_free()
	pause_menu_ui = null


func show_player_list():
	Logger.log("Showing Player List")
	player_list = InfoUIPopUp.create_info_popup("")
	add_child(player_list)


func close_player_list():
	Logger.log("Closing Player List")
	if player_list:
		player_list.queue_free()
	player_list = null


func _process(_delta):
	
	if Input.is_action_just_pressed("ui_cancel") && not multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		if pause_menu_ui:
			close_pause_menu()
		else:
			open_pause_menu()
	
	if player_list:
		var text = "Players:\n"
		for player in master.player_manager.players.keys():
			text += master.player_manager.players[player]["name"] + "\n"
	
		player_list.label.text = text
