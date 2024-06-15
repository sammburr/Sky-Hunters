class_name PWInterface # Player World Interface
extends Node3D

signal pw_used

func use():
	print("used!")
	pw_used.emit()
