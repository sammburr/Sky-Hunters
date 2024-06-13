class_name PlayerManager
extends Node

var players = {}

@export var network_player : PackedScene
@export var local_player : PackedScene

func add_local_player():
	print("Adding self ...")
	
	if local_player == null:
		print("No local player scene in Player Manager!")
		return
	
	var player_inst : LocalPlayer = local_player.instantiate()
	player_inst.name = str(multiplayer.multiplayer_peer.get_unique_id())
	
	player_inst.player_manager = self
	
	add_player(player_inst)

func add_network_player(id : int):
	print("Adding player ", id, "...")
	
	if network_player == null:
		print("No netork player scene in Player Manager!")
		return
	
	var player_inst : NetworkedPlayer = network_player.instantiate()
	player_inst.name = str(id)
	
	add_player(player_inst)

func add_player(player_inst):
	add_child(player_inst)
	
	# Only need to work out starting positions as the server, then this is broadcast to clients
	if multiplayer.is_server():
		for player : Node3D in players.keys():
			while player.position.distance_to(player_inst.position) <= 2.0:
				player_inst.position += Vector3(2.0,0.0,0.0)
	
	var values = [player_inst.name, player_inst.position, player_inst.rotation, player_inst.head.rotation]
	players[player_inst] = values

func remove_network_player(id : int):
	print("Removing player ", id, "...")
	for player : Node3D in players.keys():
		if player.name == str(id):
			remove_child(player)
			players.erase(player)

func clear_players():
	players = {}
	
	for child in get_children():
		child.queue_free()

func _process(_delta):
	if multiplayer.multiplayer_peer.CONNECTION_DISCONNECTED or multiplayer.multiplayer_peer == null:
		return
	
	if multiplayer.is_server():
		update_player_infos()
		send_player_infos.rpc(players)
		

func update_player_infos():
	for player in players.keys():
		var values = [player.name, player.position, player.rotation, player.head.rotation]
		players[player] = values

@rpc("authority", "call_remote", "unreliable_ordered")
func send_player_infos(player_infos : Dictionary):
	
	# player_infos :
	# { player_object_id : [ player_name, player_position, player_rotation, player_head_rotation ], ... }
	
	for player in players.keys():
		for values in player_infos.values():
			if values[0] == player.name:
				if player is LocalPlayer:
					player.server_position = values[1]
				else:
					player.head.rotation = values[3]
					player.rotation = values[2]
					player.position = values[1]

# Send to server only!
@rpc("any_peer", "call_remote", "unreliable_ordered")
# input_dirs = [ move.x, move.z, jump ]
func send_input_direction(input_dirs : Array):
	if not multiplayer.is_server():
		return
	
	var sender = multiplayer.get_remote_sender_id()
	
	for player in players:
		if str(sender) == player.name:
			if player is NetworkedPlayer:
				player.input_dir = Vector2(input_dirs[0], input_dirs[1])
				player.input_jump = input_dirs[2]

# Send to server only!
@rpc("any_peer", "call_remote", "reliable")
func send_rotation(rot : Vector3, head_rot : Vector3):
	if not multiplayer.is_server():
		return
	
	var sender = multiplayer.get_remote_sender_id()
	
	for player in players:
		if str(sender) == player.name:
			if player is NetworkedPlayer:
				player.head.rotation = head_rot
				player.rotation = rot
