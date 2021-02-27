extends Node2D

# pickable objects will be able to set a dialogue
# line when they are picked up.

export var obj_name : String
export var dialogue_line : String
export var player_node_path : NodePath
export var sprite_img : Texture

onready var sprite_node = $Sprite
onready var player_node = get_node(player_node_path)

signal set_dialogue(text)
signal pickup(obj_name)

func _ready():	
	# set up this obj texture
	sprite_node.texture = sprite_img
	sprite_node.position = Vector2(sprite_img.get_width() / 2 * -1, sprite_img.get_height() * -1)

func _process(delta):
	# pickup / dialogue triggers
	if Input.is_action_just_pressed("ui_accept"):
		var trigger_area : Area2D  = player_node.get_node("TriggerArea")
		if trigger_area.overlaps_area($TriggerArea):
			pickup()
			if !dialogue_line.empty():
				say_dialogue()

func say_dialogue() -> void:
	emit_signal("set_dialogue", dialogue_line)
	print(obj_name + " says: " + dialogue_line)
	
func pickup() -> void:
	emit_signal("pickup", obj_name)	
	# we can emit a signal, or we can push the obj name to a player array like so:
	# player_node.picked_objs.push(obj_name)
