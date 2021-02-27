extends KinematicBody2D

export var player_node_path : NodePath
export var sprite_img : Texture

onready var sprite_node = $Sprite
onready var player_node = get_node(player_node_path)

var screen_size

var FACE_RIGHT = 0
var FACE_LEFT = 1
var FACE_UP = 2
var FACE_DOWN = 3

var velocity = Vector2()
var speed = 200
var push_distance = 24
var travelled_distance = 0

var is_moving = false


func _ready():	
	screen_size = get_viewport_rect().size
	sprite_node.texture = sprite_img
	sprite_node.position = Vector2(sprite_img.get_width() / 2.0 * -1.0, sprite_img.get_height() / 2.0 * -1.0)
	$CollisionShape2D.position = sprite_node.position
	$CollisionShape2D.get_shape().extents = Vector2(sprite_img.get_width() / 2.0, sprite_img.get_height() / 2.0)
	$Area2D/CollisionShape2D.position = sprite_node.position
	$Area2D/CollisionShape2D.get_shape().extents = Vector2(sprite_img.get_width() / 2.0, sprite_img.get_height() / 2.0)

func _process(delta):
	
	if Input.is_action_just_pressed("ui_accept"):		
		var trigger_area : Area2D  = player_node.get_node("TriggerArea")		
		if trigger_area.overlaps_area($Area2D) and !is_moving:
			travelled_distance = 0
			is_moving = true
			velocity = push(player_node.get_direction())
			
	if is_moving and travelled_distance < push_distance:
		move_object(delta)
	elif is_moving and travelled_distance >= push_distance:
		is_moving = false
		travelled_distance = 0
		velocity = Vector2(0,0)
		
	position.x = clamp(position.x, sprite_img.get_width(), screen_size.x)
	position.y = clamp(position.y, sprite_img.get_height(), screen_size.y)

func push(direction):
	match direction:
		FACE_RIGHT:
			velocity.x += 1.0
		FACE_LEFT:
			velocity.x -= 1.0
		FACE_UP:
			velocity.y -= 1.0
		FACE_DOWN:
			velocity.y += 1.0
		_:
			print("Invalid direction")
				
	return velocity
	

func move_object(delta):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	var motion = velocity * delta
	move_and_collide(motion)
	travelled_distance += speed * delta
