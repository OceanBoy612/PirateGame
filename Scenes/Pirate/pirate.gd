extends CharacterBody2D

@export var speed = 30
@export var cannon_cooldown = 80
@export var health = 5
@export var Cannon_ball = preload("res://Scenes/Cannon_ball/cannon_ball.tscn")

enum states {PATROL, CHASE, ATTACK}
var state = states.PATROL
var can_shoot = true
var in_range = false
var cannon_timer = 0


# Target for chase mode.
var target = null

func _ready():
	set_meta("object", "pirate")
	$DetectRadius.body_entered.connect(_on_DetectRadius_body_entered)
	$DetectRadius.body_exited.connect(_on_DetectRadius_body_exited)
	$AttackRadius.body_entered.connect(_on_AttackRadius_body_entered)
	$AttackRadius.body_exited.connect(_on_AttackRadius_body_exited)
	$FireArea.body_entered.connect(_on_FireArea_body_entered)
	$FireArea.body_exited.connect(_on_FireArea_body_exited)

func _physics_process(delta):
	cannon_timer += 1
	if cannon_timer > cannon_cooldown:
		can_shoot = true

	match state:
		states.PATROL:
			rotate(0.001)
		states.CHASE:
			var goal_rotation = position.angle_to_point(target.position)
			var diff_rotation = angle_to_angle(rotation, goal_rotation)
			if diff_rotation > PI/2:
				rotate(0.005)
			elif diff_rotation < PI/2:
				rotate(-0.005)
		states.ATTACK:
			var goal_rotation = position.angle_to_point(target.position)
			var diff_rotation = angle_to_angle(rotation, goal_rotation)
			if diff_rotation > 0:
				rotate(0.005)
			elif diff_rotation < 0:
				rotate(-0.005)
			
			if can_shoot and in_range:
				can_shoot = false
				cannon_timer = 0
				var cannon_ball_instance = Cannon_ball.instantiate()
				cannon_ball_instance.init("pirate")
				get_parent().add_child(cannon_ball_instance)
				cannon_ball_instance.global_position = $LeftCannonLocation.global_position
				cannon_ball_instance.rotation = rotation
				print("FIRE!!!")
				$CannonSound.play()
	
	velocity = Vector2(0, speed).rotated(rotation)
	move_and_slide()

func _on_DetectRadius_body_entered(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.CHASE
		target = _body
		print("Enter")

func _on_DetectRadius_body_exited(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.PATROL
		target = _body
		print("Exit")

func _on_AttackRadius_body_entered(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.ATTACK
		target = _body
		print("Enter")

func _on_AttackRadius_body_exited(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.CHASE
		target = _body
		print("Exit")

func _on_FireArea_body_entered(_body):
	var object = _body.get_meta("object")
	if object == "player":
		in_range = true

func _on_FireArea_body_exited(_body):
	var object = _body.get_meta("object")
	if object == "player":
		in_range = false


func take_damage():
	$HitSound.play()
	health -= 1


static func angle_to_angle(from, to):
	return fposmod(to-from + PI, PI*2) - PI

