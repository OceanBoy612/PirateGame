extends Camera2D

@export var camera_speed = 0.02
@export var max_view = 80

@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _ready():
	position = player.position

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	var reduced_length = (mouse_position-player.position).limit_length(max_view)
	position = lerp(position, reduced_length + player.position, camera_speed)
