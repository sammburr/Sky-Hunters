class_name NetworkManager
extends Node

@export var net_ip := "127.0.0.1" #"51.155.8.241" #
@export var net_port := 2543
@export var net_max_clients := 20

var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()

@onready var ui_manager : UIManager = $"../UI"
@onready var player_manager : PlayerManager = $"../Player Manager"

func start_server():
	if not check_multiplayer_peer_start():
		return
	
	peer.create_server(net_port, net_max_clients)
	multiplayer.multiplayer_peer = peer
	
	print("Started listnening on port ", net_port)
	
	player_manager.add_local_player()
	
	# Hide start buttons from UI
	ui_manager.hide_startup_button(true)

func start_player():
	if not check_multiplayer_peer_start():
		return
	peer.create_client(net_ip, net_port)
	multiplayer.multiplayer_peer = peer

	player_manager.add_local_player()
	
	# Hide start buttons from UI
	ui_manager.hide_startup_button(true)

func disconnect_peer():
	peer = ENetMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	player_manager.clear_players()
	
	# Show start buttons from UI
	ui_manager.hide_startup_button(false)

func on_peer_connected(id : int):
	print(peer.get_unique_id(), ": Joined ++ ", id)
	player_manager.add_network_player(id)

func on_peer_disconnect(id : int):
	print(peer.get_unique_id(), ": Left -- ", id)
	player_manager.remove_network_player(id)

func on_server_disconnect():
	print("SERVER LEFT!")
	disconnect_peer()

func _ready():
	
	# Set the tick rate of the server
	Engine.max_fps = 60
	
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnect)
	multiplayer.server_disconnected.connect(on_server_disconnect)
	
	# start_server() # FOR HEADLESS SERVER

func check_multiplayer_peer_start() -> bool:
	var can_start_new_conn = true
	
	if not ( multiplayer.multiplayer_peer is OfflineMultiplayerPeer ):
		if multiplayer.multiplayer_peer == null:
			can_start_new_conn = true
		else:
			print("Already started on the network")
			can_start_new_conn = false

	return can_start_new_conn
