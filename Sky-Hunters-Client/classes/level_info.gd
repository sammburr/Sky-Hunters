class_name LevelInfo
extends Resource

@export var name : String


static func from_dict(dict : Dictionary) -> LevelInfo:
	var info = LevelInfo.new()
	info.name = dict["name"]
	return info
