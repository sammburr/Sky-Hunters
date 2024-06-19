class_name LogFormatting
extends Resource


enum Weight {
	REGULAR,
	BOLD,
	ITALIC
}


@export var weight : Weight
@export var text_color : String
@export var background_color : String = "#00000000"
@export var font_size : String
