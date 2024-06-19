# AUTOLOADED 'LevelManager'


extends Node


const levels_path = "res://scenes/levels/"

const test_level : LevelInfo = preload(levels_path + "test_level.tres")
# const new_level : LevelInfo = preload(levels_path + "new_level.tres")

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
