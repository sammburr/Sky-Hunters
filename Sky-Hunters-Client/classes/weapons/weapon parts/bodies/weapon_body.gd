class_name WeaponBody
extends Node3D


@export var stock_socket : Node3D
@export var barrel_socket : Node3D
@export var animation_player : AnimationPlayer


var current_stock_inst : Node3D
var current_barrel_inst : Node3D
var current_stock_info : PartInfo
var current_barrel_info : PartInfo


var is_busy : bool = false
var start_pos : Vector3


func add_parts(stock : PartInfo, barrel : PartInfo):
	current_stock_inst = stock.scene.instantiate()
	current_barrel_inst = barrel.scene.instantiate()
	
	current_stock_info = stock
	current_barrel_info = barrel
	
	current_stock_inst.position = stock_socket.position
	current_barrel_inst.position = barrel_socket.position


func _process(delta):
	position = lerp(position, start_pos, 0.2)


func _ready():
	start_pos = position
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)
		animation_player.animation_started.connect(_on_animation_started)


func _on_animation_finished(_anim_name : String):
	is_busy = false


func _on_animation_started(_anim_name : String):
	is_busy = true


func fire_weapon():
	assert(false, "Implement this method (Abstract!)")


func reload_weapon():
	if is_busy:
		return
	
	Logger.log("reloaded!")
	animation_player.play("Reload")


func add_recoil():
	position.x += 2.0
