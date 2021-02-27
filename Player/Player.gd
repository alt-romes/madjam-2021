extends KinematicBody2D

export var speed = 200
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	
	velocity = check_movement(velocity)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	#	$AnimatedSprite.play()
	#else:
	#	$AnimatedSprite.stop()
	
	var motion = velocity * delta
	move_and_collide(motion)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#set_animation(velocity)

func check_movement(velocity : Vector2):
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		
	return velocity


func set_animation(velocity : Vector2):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
