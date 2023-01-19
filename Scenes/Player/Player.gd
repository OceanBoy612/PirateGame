extends CharacterBody2D

@export var Cannon_ball = preload("res://Scenes/Cannon_ball/cannon_ball.tscn")
@export var speed = 100
@export var cannon_cooldown = 80
@export var health = 5

var can_shoot = true
var cannon_timer = 0

func _ready():
	set_meta("object", "player")

func _physics_process(delta):
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
		var cannon_ball_instance = Cannon_ball.instantiate()
		cannon_ball_instance.init("player")
		get_parent().add_child(cannon_ball_instance)
		cannon_ball_instance.global_position = get_node("Cannon/FireLocation").global_position
		cannon_ball_instance.rotation = $Cannon.global_rotation
		print("FIRE!!!")
		$CannonSound.play()
		
	# Apply Friction
	velocity *= 0.995
	move_and_slide()


func take_damage():
	health -= 1
