class_name Logger
extends Node


const title : LogFormatting = preload("res://classes/logger/title.tres")
const subtitle : LogFormatting = preload("res://classes/logger/subtitle.tres")
const regular : LogFormatting = preload("res://classes/logger/regular.tres")


static func log(text, formatting : LogFormatting = regular):
	if !OS.is_debug_build():
		return
	
	var weight_symbol = ""
	var weight_symbol_term = ""
	
	match formatting.weight:
		LogFormatting.Weight.REGULAR:
			weight_symbol = ""
			weight_symbol_term = ""
		LogFormatting.Weight.BOLD:
			weight_symbol = "[b]"
			weight_symbol_term = "[/b]"
		LogFormatting.Weight.ITALIC:
			weight_symbol = "[i]"
			weight_symbol_term = "[/i]"
	
	# Get class which called the function
	var stack_trace = get_stack()[1]["source"]
	
	print_rich(
		"[font_size=10]"+
		stack_trace+" :: "+
		"[/font_size]"+
		weight_symbol+
		"[color="+formatting.text_color+"]"+
		"[bgcolor="+formatting.background_color+"]"+
		"[font_size="+formatting.font_size+"]",
		text,
		"[/font_size]"+
		"[/bgcolor]"+
		"[/color]"+
		weight_symbol_term
	)
