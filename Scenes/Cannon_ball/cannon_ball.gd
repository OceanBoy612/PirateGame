extends Area2D

@export var speed = 10

func _process(delta):
	position += Vector2(speed, 0).rotated(rotation)
