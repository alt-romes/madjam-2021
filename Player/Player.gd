extends KinematicBody2D

export var speed = 200
var screen_size
var direction = 2
var frame
var collision_size = Vector2()

var FACE_RIGHT = 0
var FACE_LEFT = 1
var FACE_UP = 2
var FACE_DOWN = 3

var item_scene = preload("res://PickableObj/PickableObj.tscn")

var is_holding_item = false

func _ready():
	screen_size = get_viewport_rect().size
	frame = $AnimatedSprite.frames.get_frame("default", 0)
	collision_size = Vector2(frame.get_width() / 2.0 * $AnimatedSprite.scale.x, (frame.get_height() / 2.0 * $AnimatedSprite.scale.y))
	$TriggerArea/TriggerShape.position.x = 0
	$TriggerArea/TriggerShape.position.y = frame.get_height() / 10.0 * -1
	#$CollisionShape2D.position = $AnimatedSprite.position
	#$CollisionShape2D.get_shape().extents = collision_size

	$TriggerArea/TriggerShape.get_shape().extents = collision_size

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
	
	#var motion = velocity * delta
	velocity = move_and_slide(velocity)
	# Technically there are no borders
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	#set_animation(velocity)
	
	# input to drop picked up item
	if Input.is_action_just_pressed("player_drop_item") && is_holding_item:
		if GameState.carried_item != null:
			
			var item = item_scene.instance()
			
			print(position, "   ", global_position)
			item.global_position = global_position
			item.pickable_obj_resource = GameState.carried_item
			
			get_parent().item_dropped(item) # parent = Main
			
			
			GameState.carried_item = null
			is_holding_item = false
	

func check_movement(velocity : Vector2):
	if Input.is_action_pressed("player_right"):
		velocity.x += 1
		$AnimatedSprite.flip_h = false
		
		$TriggerArea/TriggerShape.position.x = frame.get_width() / 10.0 * 1
		$TriggerArea/TriggerShape.position.y = 0
		
		$TriggerArea/TriggerShape.get_shape().extents = collision_size
		
		direction = FACE_RIGHT
		
	elif Input.is_action_pressed("player_left"):
		velocity.x -= 1
		$AnimatedSprite.flip_h = true
		$TriggerArea/TriggerShape.position.x = frame.get_width() / 10.0 * -1
		$TriggerArea/TriggerShape.position.y = 0
		
		$TriggerArea/TriggerShape.get_shape().extents = collision_size
		
		direction = FACE_LEFT
		
	elif Input.is_action_pressed("player_up"):
		velocity.y -= 1

		$TriggerArea/TriggerShape.position.x = 0 #frame.get_width() / 2 * -1
		$TriggerArea/TriggerShape.position.y = frame.get_height() / 10.0 * -1
		
		$TriggerArea/TriggerShape.get_shape().extents = collision_size
		
		direction = FACE_UP
		
	elif Input.is_action_pressed("player_down"):
		velocity.y += 1
		
		$TriggerArea/TriggerShape.position.x = 0 #frame.get_width() / 2 * -1
		$TriggerArea/TriggerShape.position.y = frame.get_height() / 10.0 * 1
		
		$TriggerArea/TriggerShape.get_shape().extents = collision_size
		
		direction = FACE_DOWN
		
	return velocity


func set_animation(velocity : Vector2):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
