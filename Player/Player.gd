extends KinematicBody2D

export var speed = 200
var screen_size
var direction = 2
var frame

var FACE_RIGHT = 0
var FACE_LEFT = 1
var FACE_UP = 2
var FACE_DOWN = 3

func _ready():
	screen_size = get_viewport_rect().size
	frame = $AnimatedSprite.frames.get_frame("default", 0)
	$TriggerArea/TriggerShape.position.x = 0
	$TriggerArea/TriggerShape.position.y = frame.get_height() / 10 * -1
	$CollisionShape2D.position = $AnimatedSprite.position
	$CollisionShape2D.get_shape().extents = Vector2(frame.get_width() / 2, frame.get_height() / 2)

	$TriggerArea/TriggerShape.get_shape().extents = Vector2(frame.get_width() / 2, (frame.get_height() / 2))

func get_direction():
	return direction

func _physics_process(delta):
	var velocity = Vector2()
	
	velocity = check_movement(velocity)
	
	#rotation = dir
	
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
		$AnimatedSprite.flip_h = false
		
		$TriggerArea/TriggerShape.position.x = frame.get_width() / 10 * 1
		$TriggerArea/TriggerShape.position.y = 0
			
		$TriggerArea/TriggerShape.get_shape().extents = Vector2(frame.get_width() / 2, (frame.get_height() / 2))
		
		direction = FACE_RIGHT
		
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$AnimatedSprite.flip_h = true
		$TriggerArea/TriggerShape.position.x = frame.get_width() / 10 * -1
		$TriggerArea/TriggerShape.position.y = 0
		
		$TriggerArea/TriggerShape.get_shape().extents = Vector2(frame.get_width() / 2, (frame.get_height() / 2))
		
		direction = FACE_LEFT
		
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1

		$TriggerArea/TriggerShape.position.x = 0 #frame.get_width() / 2 * -1
		$TriggerArea/TriggerShape.position.y = frame.get_height() / 10 * -1
		
		$TriggerArea/TriggerShape.get_shape().extents = Vector2(frame.get_width() / 2, (frame.get_height() / 2))
		
		direction = FACE_UP
		
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		
		$TriggerArea/TriggerShape.position.x = 0 #frame.get_width() / 2 * -1
		$TriggerArea/TriggerShape.position.y = frame.get_height() / 10 * 1
		
		$TriggerArea/TriggerShape.get_shape().extents = Vector2(frame.get_width() / 2, (frame.get_height() / 2))
		
		direction = FACE_DOWN
		
	return velocity


func set_animation(velocity : Vector2):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
