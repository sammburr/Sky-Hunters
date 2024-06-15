class_name PWInterface # Player World Interface
extends StaticBody3D

signal pw_used

func use():
	pw_used.emit()
