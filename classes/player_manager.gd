# TODO: refactor all code as this as an autoload

class_name PlayerManager
extends Node

# [ [ player_name, player_pos, player_rotation, player_head_rotation ], ... ]
var players = []

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
		for player_info : Array in players:
			var player_name = player_info[0]
			for player : Node3D in get_children():
				if player.name == player_name:
					while player.position.distance_to(player_inst.position) <= 2.0:
						player_inst.position += Vector3(2.0,0.0,0.0)
	
	var values = [player_inst.name] # Just init with empty player info as we will update this every server tick
	players.append(values)

func remove_network_player(id : int):
	print("Removing player ", id, "...")
	var i = 0
	for player_info : Array in players:
		var player_name = player_info[0]
		for player : Node3D in get_children():
			if player.name == player_name:
				if player.name == str(id):
					remove_child(player)
					players.remove_at(i)
		i += 1

func clear_players():
	players = []
	
	for child in get_children():
		child.queue_free()

func _process(_delta):
	if multiplayer.multiplayer_peer.CONNECTION_DISCONNECTED or multiplayer.multiplayer_peer == null:
		return
	
	if multiplayer.is_server():
		update_player_infos()
		for player_info in players:
			for player : Player in get_children():
				if player_info[0] == player.name && player is NetworkedPlayer:
					reflect_info.rpc_id(player.name.to_int(), Vector2(player_info[1].x, player_info[1].z), player.current_input_type)
				elif player is NetworkedPlayer:
					send_player_info.rpc_id(player.name.to_int(), player_info[0], player_info[1], player_info[2], player_info[3])

func update_player_infos():
	
	var player_rot : float
	var player_head_rot : float
	
	var i = 0
	for player_info : Array in players:
		var player_name = player_info[0]
		for player : Player in get_children():
			if player.name == player_name:
				
				player_rot = player.rotation.y
				player_head_rot = player.head.rotation.x
				
				var values = [player.name, player.position, player_rot, player_head_rot]
				players[i] = values
				break
		i += 1

@rpc("authority", "call_remote", "unreliable_ordered")
func reflect_info(player_pos : Vector2, player_input_type : Player.InputType): # Send the flat position to clients
	for player : Player in get_children():
		if player is LocalPlayer:
			player.current_input_type = player_input_type
			player.server_position = player_pos

@rpc("authority", "call_remote", "unreliable_ordered")
func send_player_info(player_name : String, player_pos : Vector3, player_rotation : float, player_head_rotation : float):
	# [  player_name, player_pos, player_rotation, player_head_rotation, input_type ]

	for player : Player in get_children():
		if player.name == player_name:
			player.head.rotation.x = player_head_rotation
			player.rotation.y = player_rotation
			player.position = player_pos

# Send to server only!
@rpc("any_peer", "call_remote", "unreliable_ordered")
# input_dirs = [ move.x, move.z, jump ]
func send_input_direction(input_dirs : Array):
	if not multiplayer.is_server():
		return
	
	var sender = multiplayer.get_remote_sender_id()
	
	for player in get_children():
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
	
	for player in get_children():
		if str(sender) == player.name:
			if player is NetworkedPlayer:
				player.head.rotation = head_rot
				player.rotation = rot

@rpc("any_peer", "call_remote", "reliable")
func try_interact():
	if not multiplayer.is_server():
		return
	
	var sender = multiplayer.get_remote_sender_id()
	
	for player in get_children():
		if str(sender) == player.name:
			if player is NetworkedPlayer:
				player.did_just_interact = true
