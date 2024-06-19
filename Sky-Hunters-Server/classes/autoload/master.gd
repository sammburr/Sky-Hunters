# AUTOLOADED 'Master'


extends Node


@onready var network_manager : NetworkManager = get_node("/root/NetworkManager")
@onready var level_manager : LevelManager = get_node("/root/LevelManager")
@onready var player_manager : PlayerManager = get_node("/root/PlayerManager")


func _ready():
	Logger.log("Starting Application...", Logger.title)
	
	Engine.max_fps = 64
	Logger.log("Server targeting 64fps", Logger.subtitle)
	
	network_manager.on_server_started.connect(_on_server_started)
	network_manager.start_server()
	
	# Load a level
	level_manager.load_level(level_manager.test_level)


func _on_server_started():
	Logger.log("Server started")
