class_name BreakActionBody
extends WeaponBody


@export var hindge : Node3D


var loaded_shells : int


func _ready():
	super._ready()
	
	loaded_shells = current_barrel_info.number_barrels
	hindge.add_child(current_barrel_inst)
	add_child(current_stock_inst)
	

func fire_weapon():
	if is_busy:
		return
	
	if loaded_shells > 0:
		Logger.log("fired!")
		add_recoil()
		loaded_shells -= 1
	else:
		reload_weapon()


func reload_weapon():
	super.reload_weapon()
	loaded_shells = current_barrel_info.number_barrels
