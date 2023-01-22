extends CharacterBody2D

@export var speed = 50
@export var turn_speed = 0.005
@export var cannon_cooldown = 120
@export var health = 5
@export var Cannon_ball = preload("res://Scenes/Cannon_ball/cannon_ball.tscn")

enum states {PATROL, CHASE, ATTACK}
var state = states.PATROL
var can_shoot = true
var in_range = false
var in_range_right = false
var cannon_timer = 0
var things_in_right_feeler = 0
var things_in_left_feeler = 0


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
	$FireAreaRight.body_entered.connect(_on_FireAreaRight_body_entered)
	$FireAreaRight.body_exited.connect(_on_FireAreaRight_body_exited)
	$LeftFeeler.body_entered.connect(_on_LeftFeeler_body_entered)
	$LeftFeeler.body_exited.connect(_on_LeftFeeler_body_exited)
	$RightFeeler.body_entered.connect(_on_RightFeeler_body_entered)
	$RightFeeler.body_exited.connect(_on_RightFeeler_body_exited)

func _physics_process(_delta):
	if global_position.x > 2300:
		global_position.x = 2200
	if global_position.x < -2300:
		global_position.x = -2200
	if global_position.y > 2000:
		global_position.y = 1900
	if global_position.y < -2000:
		global_position.y = -1900
	cannon_timer += 1
	if cannon_timer > cannon_cooldown:
		can_shoot = true

	var next_rotation = 0
	match state:
		states.PATROL:
			next_rotation = turn_speed
		states.CHASE:
			var goal_rotation = position.angle_to_point(target.position)
			var diff_rotation = angle_to_angle(rotation, goal_rotation)
			if diff_rotation > PI/2 or diff_rotation < -PI/2:
				next_rotation = turn_speed
			else:
				next_rotation = -turn_speed
		states.ATTACK:
			var goal_rotation = position.angle_to_point(target.position)
			var diff_rotation = angle_to_angle(rotation, goal_rotation)
			var first_range = diff_rotation < 3*PI/4 and diff_rotation > PI/2
			var second_range = diff_rotation < PI/4 and diff_rotation > -PI/2 
			if first_range or second_range:
				next_rotation = -turn_speed
			else:
				next_rotation = turn_speed
	
	if can_shoot and in_range:
		can_shoot = false
		$AnimateLeftCannon.play("Fire")

	if can_shoot and in_range_right:
		can_shoot = false
		$AnimateRightCannon.play("Fire")

	if things_in_right_feeler > 0:
		rotate(turn_speed)
	elif things_in_left_feeler > 0:
		rotate(-turn_speed)
	else:
		rotate(next_rotation)
	velocity = Vector2(0, speed).rotated(rotation)
	move_and_slide()

func _on_DetectRadius_body_entered(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.CHASE
		target = _body

func _on_DetectRadius_body_exited(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.PATROL
		target = _body

func _on_AttackRadius_body_entered(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.ATTACK
		target = _body

func _on_AttackRadius_body_exited(_body):
	var object = _body.get_meta("object")
	if object == "player":
		state = states.CHASE
		target = _body

func _on_FireArea_body_entered(_body):
	var object = _body.get_meta("object")
	if object == "player":
		in_range = true

func _on_FireArea_body_exited(_body):
	var object = _body.get_meta("object")
	if object == "player":
		in_range = false

func _on_FireAreaRight_body_entered(_body):
	var object = _body.get_meta("object")
	if object == "player":
		in_range_right = true

func _on_FireAreaRight_body_exited(_body):
	var object = _body.get_meta("object")
	if object == "player":
		in_range_right = false


func _on_LeftFeeler_body_entered(_body):
	things_in_left_feeler += 1

func _on_LeftFeeler_body_exited(_body):
	if things_in_left_feeler > 0:
		things_in_left_feeler -= 1

func _on_RightFeeler_body_entered(_body):
	things_in_right_feeler += 1

func _on_RightFeeler_body_exited(_body):
	if things_in_right_feeler > 0:
		things_in_right_feeler -= 1


func take_damage():
	$HitSound.play()
	health -= 1


func angle_to_angle(from, to):
	return fposmod(to-from + PI, PI*2) - PI

func _on_animation_fire_left():
	cannon_timer = 0
	var cannon_ball_instance = Cannon_ball.instantiate()
	cannon_ball_instance.init("pirate", velocity*0.01)
	get_parent().add_child(cannon_ball_instance)
	cannon_ball_instance.global_position = $LeftCannonLocation.global_position
	cannon_ball_instance.rotation = rotation + PI/4
	cannon_ball_instance.set_starting_position()
	$CannonSound.play()


func _on_animation_fire_right():
	cannon_timer = 0
	var cannon_ball_instance = Cannon_ball.instantiate()
	cannon_ball_instance.init("pirate", velocity*0.02)
	get_parent().add_child(cannon_ball_instance)
	cannon_ball_instance.global_position = $RightCannonLocation.global_position
	cannon_ball_instance.rotation = rotation + 3*PI/4
	cannon_ball_instance.set_starting_position()
	$CannonSound.play()
