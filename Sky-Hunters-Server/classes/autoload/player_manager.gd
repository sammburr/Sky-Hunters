# AUTOLOADED 'PlayerManager'


extends Node


const player_scene = preload("res://scenes/player/player.tscn")
const default_player_settings : PlayerSettings = preload("res://classes/default_player_settings.tres")


@onready var master : Master = get_node("/root/Master")


# players = { "id": { "name": ..., "speed": ... }, ... }
var players = {}


func _process(_delta):
	var player_transform_map = PackedByteArray([0,0,0,0,0,0,0,0,0,0])
	
	for child in get_children():
		if child is Player && child.has_moved:
			player_transform_map.encode_half(0, child.position.x)
			player_transform_map.encode_half(2, child.position.y)
			player_transform_map.encode_half(4, child.position.z)
			
			player_transform_map.encode_half(6, child.head.rotation.x)
			player_transform_map.encode_half(8, child.rotation.y)
	
			# Logger.log(player_transform_map)
			master.network_manager.mirror_player_transform.rpc(child.name.to_int(), player_transform_map)
		player_transform_map = PackedByteArray([0,0,0,0,0,0,0,0,0,0])


func add_player(id : int):
	players[str(id)] = { "name":str(id), "speed":default_player_settings.speed }
	Logger.log(players)
	
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)


func remove_player(id : int):
	players.erase(str(id))
	Logger.log(players)
	
	for child in get_children():
		if child.name == str(id):
			child.queue_free()


func move_player(id : int, input_map : PackedByteArray):
	for child in get_children():
		if child is Player && child.name == str(id):
			child.move_player(input_map)


func try_interact(id : int):
	for child in get_children():
		if child is Player && child.name == str(id):
			child.try_interact()


func set_player_name(id : int, player_name : String):
	players[str(id)]["name"] = player_name
	Logger.log(players)


func get_player_settings(id : int) -> Dictionary:
	for player in players.keys():
		if int(player) == id:
			return players[player]
	return Dictionary()
