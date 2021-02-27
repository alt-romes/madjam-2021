extends Area2D

export var speed = 200
var screen_size
var is_interacting

signal talk

func _ready():
	screen_size = get_viewport_rect().size
	is_interacting = false

func _process(delta):
	var velocity = Vector2()
	
	velocity = check_movement(velocity)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	check_interaction()

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
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func check_interaction():
	if Input.is_key_pressed(KEY_SPACE) && !is_interacting:
		is_interacting = true
		emit_signal("talk")


func _on_Player_talk():
	pass # Replace with function body.
