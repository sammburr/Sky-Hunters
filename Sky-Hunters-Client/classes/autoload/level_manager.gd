# AUTOLOADED 'LevelManager'


extends Node


const levels_path = "res://scenes/levels/"

var levels = {
	"TestLevel" : "test_level.tscn"
  # "NewLevel"  : "new_level.tscn"
}

var current_level : Node3D


func load_level(info : LevelInfo):
	Logger.log("Loading level: " + info.name + "...")
	
	for level_name in levels.keys():
		if level_name == info.name:			
			var level : PackedScene = load(levels_path + levels[level_name])
			current_level = level.instantiate()
			add_child(current_level)
			
			Logger.log("Loaded level: " + info.name)


func unload_level():
	Logger.log("Unloading level")
	
	for child in get_children():
		child.queue_free()
