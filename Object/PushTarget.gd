extends Node2D

export var object_node_path : NodePath
export var sprite_img : Texture

onready var sprite_node = $Sprite
onready var object_node = get_node(object_node_path)

var screen_size
var in_place = false

func _ready():
	screen_size = get_viewport_rect().size
	sprite_node.texture = sprite_img
	sprite_node.position = Vector2(sprite_img.get_width() / 2.0 * -1.0, sprite_img.get_height() / 2.0 * -1.0)
	$Area2D/CollisionShape2D.position = sprite_node.position
	$Area2D/CollisionShape2D.get_shape().extents = Vector2(sprite_img.get_width() / 2.0, sprite_img.get_height() / 2.0)
	position.x = position.x / 24 * 24 + 12
	position.y = position.y / 24 * 24 + 12


func _process(delta):
	var trigger_area : Area2D  = object_node.get_node("Area2D")
	if trigger_area.overlaps_area($Area2D) and !in_place:
		in_place = true
	elif !trigger_area.overlaps_area($Area2D) and in_place:
		in_place = false
	
