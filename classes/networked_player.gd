class_name NetworkedPlayer
extends Player

var input_dir : Vector2
var input_jump : float

@onready var name_label : Label3D = $Name

func _ready():
	name_label.text = name

func _physics_process(delta):
	
	if not multiplayer.is_server():
		return
	
	apply_gravity()

	if input_jump and is_on_floor():
		player_jump()

	player_move(input_dir)
