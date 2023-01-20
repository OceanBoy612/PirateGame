extends Area2D

@export var speed = 6
@export var flying_range = 400
var object_origin = null
var starting_position = Vector2(0,0)
var death_timer = 50
var timer = 0
var hit = false
var played_sound = false
var starting_velocity = Vector2(0,0)

func init(object, s_v):
	object_origin = object
	starting_velocity = s_v

func set_starting_position():
	starting_position = global_position
	

func _ready():
	self.body_entered.connect(_on_HitBox_body_entered)
	$Explode.hide()
	$Explode.animation_finished.connect(_on_Explode_animation_finished)

func _process(_delta):
	if global_position.distance_to(starting_position) > flying_range:
		hit = true
	
	if hit:
		$Sprite2D.hide()
		timer += 1
	else:
		position += Vector2(speed, 0).rotated(rotation) + starting_velocity
	if timer > death_timer:
		queue_free()

func _on_HitBox_body_entered(_body):
	var object = _body.get_meta("object")
	if object != object_origin and _body.has_method("take_damage"):
		_body.take_damage()
		hit = true
		$Explode.show()
		$Explode.play("Explode")

func _on_Explode_animation_finished():
	$Explode.hide()

