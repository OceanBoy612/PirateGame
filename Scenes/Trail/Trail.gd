extends Line2D

@export var length = 50
@export var trail_length = 100

var point = Vector2()

func ready():
	set_as_top_level(true)

func _physics_process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	
	point = get_parent().global_position
	add_point(point)
		
	if points.size() > trail_length:
		remove_point(0)
