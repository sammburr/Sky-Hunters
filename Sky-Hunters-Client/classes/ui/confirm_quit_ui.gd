class_name ConfirmQuitUIPopUp
extends Control


const confirm_quit_popup = preload("res://scenes/ui/confirm_quit_ui.tscn")


func _on_quit_pressed():
	Logger.log("quit pressed")
	
	queue_free()
	get_tree().quit()


func _on_cancel_pressed():
	Logger.log("cancel pressed")
	
	queue_free()


# try: add_child(ConfirmQuitPopUp.create_popup())
static func create_popup() -> ConfirmQuitUIPopUp:
	return confirm_quit_popup.instantiate()
