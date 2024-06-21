# AUTOLOADED 'PlayerManager'


extends Node


const local_player_scene = preload("res://scenes/player/local_player.tscn")
const network_player_scene = preload("res://scenes/player/network_player.tscn")


# players = { "id": { "name": ..., "speed": ... }, ... }
var players = {}

var player_nodes = []

var did_just_players_update := false


func add_network_player(id : int):
	var network_player = network_player_scene.instantiate()
	network_player.name = str(id)
	player_nodes.append(network_player)
	add_child(network_player)


func add_local_player():
	var local_player = local_player_scene.instantiate()
	local_player.name = "local_player"
	player_nodes.append(local_player)
	add_child(local_player)


func remove_player(id : int):
	var i = 0
	for child in player_nodes:
		if child.name == str(id):
			child.queue_free()
			player_nodes.remove_at(i)
		i += 1


func clear_players():
	for child in player_nodes:
		child.queue_free()

	player_nodes = []
	players = {}


func _process(_delta):
	if did_just_players_update:
		
		for player_id : String in players.keys():
			if int(player_id) != multiplayer.multiplayer_peer.get_unique_id():
				var has_player_node = false
				for player : Node3D in player_nodes:
					if player.name == player_id:
						has_player_node = true
				if !has_player_node:
					var new_player = network_player_scene.instantiate()
					new_player.name = player_id
					player_nodes.append(new_player)
					add_child(new_player)
		
		did_just_players_update = false


func get_local_player_settings() -> Dictionary:
	for player in players.keys():
		if int(player) == multiplayer.multiplayer_peer.get_unique_id():
			return players[player]
	return Dictionary()
