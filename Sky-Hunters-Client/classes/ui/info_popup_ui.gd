class_name InfoUIPopUp
extends Control


const info_popup_scene = preload("res://scenes/ui/info_popup_ui.tscn")


var label_text : String
var should_block_input : bool = false


@onready var label : Label = $MarginContainer/VBoxContainer/Label


func _ready():
	# This is done to stop info box blocking input to other active control nodes
	if !should_block_input:
		propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE]) 
	
	label.text = label_text


# Create an instance of an InfoUIPopUp box with a given string
# try: add_child(create_info_popup("this is an info box!"))
static func create_info_popup(info : String, is_blocking : bool = false) -> InfoUIPopUp:
	var instance : InfoUIPopUp = info_popup_scene.instantiate()
	instance.label_text = info
	instance.should_block_input = is_blocking
	return instance
