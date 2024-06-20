# AUTOLOADED 'Master'


extends Node


@onready var network_manager : NetworkManager = get_node("/root/NetworkManager")
@onready var ui_manager : UIManager = get_node("/root/UIManager")
@onready var level_manager : LevelManager = get_node("/root/LevelManager")
@onready var player_manager : PlayerManager = get_node("/root/PlayerManager")
@onready var entity_manager : EntityManager = get_node("/root/EntityManager")


func _ready():
	Logger.log("Starting Application...", Logger.title)
	Logger.log("Loading main menu UI...", Logger.subtitle)
	
	ui_manager.open_main_menu()


