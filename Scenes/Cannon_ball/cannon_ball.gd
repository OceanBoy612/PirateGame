extends Area2D

@export var speed = 10
var object_origin = null

func _ready():
	body_entered.connect(_on_HitBox_body_entered)

func init(object):
	object_origin = object

func _process(delta):
	position += Vector2(speed, 0).rotated(rotation)

func _on_HitBox_body_entered(_body):
	var object = _body.get_meta("object")
	if object != object_origin:
		print(object)
#		object.take_damage()
		queue_free()

