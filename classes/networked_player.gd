class_name NetworkedPlayer
extends CharacterBody3D

@export var speed = 200

var input_dir : Vector2

@onready var name_label : Label3D = $Name
@onready var head = $Head

func _ready():
	name_label.text = name

func _physics_process(delta):
	if not multiplayer.is_server():
		return
	
	if not is_on_floor():
		velocity.y -= 9.81 * delta

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x
	velocity.z = direction.z
	
	move_and_slide()
