class_name GattlingBody
extends WeaponBody


@export var crank : Node3D
@export var gattle : Node3D


var current_spin : float
var last_tick_rotation : float
var did_just_fire : bool = false
var rot_per_fire : float


func _process(delta):
	super._process(delta)
	
	current_spin = lerp(current_spin, 0.0, 0.01)
	
	crank.rotation.z += current_spin
	gattle.rotation.x += current_spin
	var rot_mod = fmod(crank.rotation.z, deg_to_rad(rot_per_fire))

	if rot_mod > deg_to_rad(rot_per_fire) - 0.1 && !did_just_fire:
		did_just_fire = true
		Logger.log("fired!")
		add_recoil()
	if rot_mod < 0.1:
		did_just_fire = false
	
	last_tick_rotation = crank.rotation.z
	

func _ready():
	super._ready()
	
	rot_per_fire = 90.0 / current_barrel_info.number_barrels
	
	add_child(current_barrel_inst)
	add_child(current_stock_inst)
	


func fire_weapon():
	if is_busy:
		return

	current_spin += 0.01
	


func reload_weapon():
	super.reload_weapon()
