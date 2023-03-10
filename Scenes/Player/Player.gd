extends CharacterBody2D

@export var Cannon_ball = preload("res://Scenes/Cannon_ball/cannon_ball.tscn")
@export var speed = 120
@export var cannon_cooldown = 140
@export var health = 5

var can_shoot = true
var cannon_timer = 0

func _ready():
	set_meta("object", "player")
	$SailingSounds.play()

func _physics_process(_delta):
	if global_position.x > 2300:
		global_position.x = 2200
	if global_position.x < -2300:
		global_position.x = -2200
	if global_position.y > 2000:
		global_position.y = 1900
	if global_position.y < -2000:
		global_position.y = -1900
	var goal_rotation = position.angle_to_point(get_global_mouse_position())
	var diff_rotation = angle_to_angle(rotation, goal_rotation)
	if diff_rotation > -PI/8 or diff_rotation < -PI/8*7:
		$Cannon.look_at(get_global_mouse_position())
	cannon_timer += 1
	if cannon_timer > cannon_cooldown:
		can_shoot = true
	
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2(0, speed).rotated(rotation)
	if Input.is_action_pressed("ui_down"):
		velocity *= 0.99
	if Input.is_action_pressed("ui_right"):
		rotate(0.02)
		velocity = velocity.rotated(0.02)
	if Input.is_action_pressed("ui_left"):
		rotate(-0.02)
		velocity = velocity.rotated(-0.02)
	if Input.is_action_pressed("ui_accept") and can_shoot:
		can_shoot = false
		cannon_timer = 0
		$FireAnimation.play("Fire")
		var cannon_ball_instance = Cannon_ball.instantiate()
		cannon_ball_instance.init("player", velocity*0.01)
		get_parent().add_child(cannon_ball_instance)
		cannon_ball_instance.global_position = get_node("Cannon/FireLocation").global_position
		cannon_ball_instance.rotation = $Cannon.global_rotation
		cannon_ball_instance.set_starting_position()
		$CannonSound.play()
		
	# Apply Friction
	velocity *= 0.995
	move_and_slide()


func take_damage():
	health -= 1

func angle_to_angle(from, to):
	return fposmod(to-from + PI, PI*2) - PI
