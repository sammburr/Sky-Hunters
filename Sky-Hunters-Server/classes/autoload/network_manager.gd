# AUTOLOADED 'NetworkManager'


extends Node


signal on_server_started


@onready var master : Master = get_node("/root/Master")


var port : int = 2543
var max_clients : int = 64
# Channels
# 1 : Player Info
# 2 : Level Info
var channels : int = 2

var did_just_connect : bool = false


func start_server():
	Logger.log("Starting server on port " + str(port))
	
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_clients, channels)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.multiplayer_peer.peer_connected.connect(_on_peer_connected)
	multiplayer.multiplayer_peer.peer_disconnected.connect(_on_peer_disconnected)


func _process(_delta):
	if !did_just_connect && multiplayer.multiplayer_peer.get_connection_status() == multiplayer.multiplayer_peer.CONNECTION_CONNECTED:
		on_server_started.emit()
		did_just_connect = true
		

func _on_peer_connected(id : int):
	Logger.log("Player Join: " + str(id))	
	Logger.log("Sending level to " + str(id))
	change_level.rpc_id(id, master.level_manager.test_level.to_dict())
	master.player_manager.add_player(id)
	
	mirror_players.rpc(master.player_manager.players)


func _on_peer_disconnected(id : int):
	Logger.log("Player Left: " + str(id))
	master.player_manager.remove_player(id)

	mirror_players.rpc(master.player_manager.players)	


@rpc("any_peer", "call_remote", "reliable", 1)
func set_player_name(player_name : String):
	if player_name.is_empty():
		return
	
	var sender = multiplayer.get_remote_sender_id()
	master.player_manager.set_player_name(sender, player_name)

	mirror_players.rpc(master.player_manager.players)


# PackedByteArray represents:
# [ | w, a, s, d, j, c, -, - | , |head_rot|, |body_rot| ]

@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func set_player_input_map(map : PackedByteArray):
	
	var sender = multiplayer.get_remote_sender_id()
	master.player_manager.move_player(sender, map)
	
	# Logger.log(Helpers.byte_as_binary(map[1]))
	# Logger.log(Helpers.byte_as_binary(map[2]))


@rpc("authority", "call_remote", "reliable", 2)
func change_level(_level_info : Dictionary):
	pass


@rpc("authority", "call_remote", "reliable", 1)
func mirror_players(_dict : Dictionary):
	pass


# PackedFloat32Array represents:
# [ | posx | , | posy |, | posz |]

@rpc("authority", "call_local", "unreliable_ordered", 1)
func mirror_player_transform(_id : int, _map : PackedByteArray):
	pass
