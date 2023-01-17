extends CharacterBody2D

@export var speed = 60

enum states {PATROL, CHASE, ATTACK}
var state = states.PATROL
# Target for chase mode.
var target = null

func _ready():
	$DetectRadius.body_entered.connect(_on_DetectRadius_area_entered)
	$DetectRadius.body_exited.connect(_on_DetectRadius_area_exited)

func _physics_process(delta):
	match state:
		states.PATROL:
			rotate(0.01)
		states.CHASE:
			pass
#			print(angle_thing)
#			print(position.angle_to_point(target.position))
#			if angle_thing > 0:
#				rotate(0.01)
#			else:
#				rotate(-0.01)
		states.ATTACK:
			pass
	
	velocity = Vector2(0, speed).rotated(rotation)
	move_and_slide()

func _on_DetectRadius_area_entered(body):
	print("Enter")

func _on_DetectRadius_area_exited(body):
	print("Exit")


#func _on_AttackRadius_body_exited(body):
#	state = states.CHASE

