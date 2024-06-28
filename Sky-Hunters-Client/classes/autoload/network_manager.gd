# AUTOLOADED 'NetworkManager'


extends Node


@onready var master : Master = get_node("/root/Master")

# Channels
# 1 : Player Info
# 2 : Level Info
# 3 : Blimp Info
# 4 : Entity Info
var channels : int = 4
var player_name : String = ""


func _ready():
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_client_connected)
	multiplayer.peer_disconnected.connect(_on_client_disconnected)


# ip and port are assumed to be valid
func connect_to_server(ip : String, port : int, user_name : String):
	Logger.log("Connecting to server...")
	
	self.player_name = user_name
	
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port, channels)
	multiplayer.multiplayer_peer = peer


func disconnect_from_server():
	if multiplayer.multiplayer_peer.get_connection_status() != multiplayer.multiplayer_peer.CONNECTION_CONNECTED:
		return
	
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	master.ui_manager.open_main_menu()
	master.level_manager.unload_level()
	master.player_manager.clear_players()
	master.entity_manager.blimp_instance = null
	


func _on_connected_to_server():
	Logger.log("Connected to the server!")
	
	set_player_name.rpc_id(1, player_name)
	master.ui_manager.close_main_menu()
	master.ui_manager.show_player_list()
	master.player_manager.add_local_player()


func _on_client_connected(id : int):
	if id != 1:
		master.player_manager.add_network_player(id)


func _on_client_disconnected(id : int):
	master.player_manager.remove_player(id)


# PackedByteArray represents:
# [ | w, a, s, d, j, c, -, - | , |head_rot|, |body_rot| ]

@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func set_player_input_map(_map : PackedByteArray):
	pass


@rpc("any_peer", "call_remote", "reliable", 1)
func set_player_name(_player_name : String):
	pass


@rpc("any_peer", "call_remote", "reliable", 1)
func try_interact():
	pass


@rpc("authority", "call_remote", "reliable", 2)
func change_level(dict : Dictionary):
	var level_info : LevelInfo = LevelInfo.from_dict(dict)
	master.level_manager.load_level(level_info)


@rpc("authority", "call_remote", "reliable", 1)
func mirror_players(dict : Dictionary):
	master.player_manager.players = dict
	master.player_manager.did_just_players_update = true
	Logger.log(dict)


# PackedFloat32Array represents:
# [ | posx | , | posy |, | posz |]

@rpc("authority", "call_remote", "unreliable_ordered", 1)
func mirror_player_transform(id : int, map : PackedByteArray):
	
	var postition = Vector3(map.decode_half(0), map.decode_half(2), map.decode_half(4))
	var head_rot = map.decode_half(6)
	var player_rot = map.decode_half(8)
	
	if id == multiplayer.multiplayer_peer.get_unique_id():
		for child in master.player_manager.player_nodes:
			if child is LocalPlayer:
				child.move_player(postition, head_rot, player_rot)
	else:
		for child in master.player_manager.player_nodes:
			if child is NetworkPlayer && child.name == str(id):
				child.move_player(postition, head_rot, player_rot)


# [ helm_value, steam_value, air_value, | posx, posx |, ..., | roty, roty | ]
@rpc("authority", "call_remote", "unreliable_ordered", 3)
func update_blimp(state : PackedByteArray):
	var pos = Vector3(
		state.decode_half(3),
		state.decode_half(5),
		state.decode_half(7)
	)
	var rot = state.decode_half(9)
	
	if !master.entity_manager.blimp_instance:
		# Spawn blimp in
		master.entity_manager.spawn_blimp(pos, rot)
	
	master.entity_manager.blimp_instance.update_blimp(state)


# [ entity_id, entity_type, entity_config]
@rpc("authority", "call_remote", "reliable", 4)
func add_entity(state : PackedByteArray):
	var id = state.decode_u8(0)
	var type = state.decode_u8(1)
	var config = state.decode_u8(2)
	Logger.log(int(str(config).substr(2)))
	Logger.log(int(str(config).substr(1)))
	Logger.log(int(str(config).substr(0)))

	var dict_config = {
		"stock": master.weapon_manager.stocks[int(str(config).substr(2))],
		"body": master.weapon_manager.bodies[int(str(config).substr(1,1))],
		"barrel": master.weapon_manager.barrels[int(str(config).substr(0,1))],
	}
	master.entity_manager.add_entity(id, type, dict_config)


# [ entity_id, | posx, posx | , ... ]
@rpc("authority", "call_remote", "unreliable_ordered", 4)
func update_entity(state : PackedByteArray):
	var id = state.decode_u8(0)
	var pos = Vector3(
		state.decode_half(1),
		state.decode_half(3),
		state.decode_half(5)
	)
	
	for entity : Node3D in master.entity_manager.entities:
		if entity.name == str(id):
			entity.position = pos
