extends Node2D

# pickable objects will be able to set a dialogue
# line when they are picked up.

export var pickable_obj_resource : Resource
export var player_node_path : NodePath

var sprite_node
var player_node
#onready var dialogue_node = get_node("../Dialogue")

var res : PickableObjData
#var dialogue : Dialogue

signal set_dialogue(text)
signal pickup(obj_name, resource)

func _ready():		
	res = pickable_obj_resource
#	dialogue = Dialogue.new([res.dialogue_line])
	
	sprite_node = $Sprite
	player_node = get_node(player_node_path)	
	
	# set up this obj texture
	sprite_node.texture = res.texture
	sprite_node.position = Vector2(res.texture.get_width() / 2 * -1, res.texture.get_height() * -1)
	
	connect("pickup", GameState, "_on_item_pickup")

func _process(delta):
	# pickup / dialogue triggers
	if Input.is_action_just_pressed("player_interact"):
		
		var trigger_area : Area2D  = player_node.get_node("TriggerArea")
		
		if trigger_area.overlaps_area($TriggerArea) and !player_node.is_holding_item:
			emit_signal("pickup", res)
			player_node.is_holding_item = true
			
			if !res.dialogue_line.empty():
				say_dialogue()
				
			queue_free()

func say_dialogue() -> void:
	emit_signal("set_dialogue", res.dialogue_line)
	#dialogue_node.emit_signal("dialogue_interact", dialogue)
	print(res.name + " says: " + res.dialogue_line)
	
