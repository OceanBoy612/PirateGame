extends CharacterBody2D

# move mostly striaght avoiding land

# move toward player

# When in range broadside + fire


func _physics_process(delta):

	move_and_slide()


func approach():
	pass

func boradside():
	pass
