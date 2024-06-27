class_name BoltActionBody
extends WeaponBody


var loaded_shells : int
var magazine_count : int


func _ready():
	super._ready()
	
	loaded_shells = current_barrel_info.number_barrels
	magazine_count = 3
	
	add_child(current_barrel_inst)
	add_child(current_stock_inst)
	

func fire_weapon():
	if is_busy:
		return
	
	if loaded_shells > 0:
		Logger.log("fired!")
		add_recoil()
		loaded_shells -= 1
	else:
		if magazine_count > current_barrel_info.number_barrels:
			animation_player.play("Chamber")
			loaded_shells = current_barrel_info.number_barrels
			magazine_count -= current_barrel_info.number_barrels
		else:
			reload_weapon()


func reload_weapon():
	super.reload_weapon()
	loaded_shells = current_barrel_info.number_barrels
	magazine_count = 10
