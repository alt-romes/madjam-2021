extends Node2D

# pickable objects will be able to set a dialogue
# line when they are picked up.

class_name PickableObj

export var pickable_obj_resource : Resource

onready var main_node = get_node("../../../../../") # p: Objects, p: YScroll, p: Level0, p: Levels, p: Main
onready var player_node = main_node.get_node("Player")
onready var dialogue_node = get_tree().root.get_node("Control/CanvasLayer/Dialogue")

var sprite_node

var dialogue : Dialogue
var res : PickableObjData
var sentences : PoolStringArray

signal set_dialogue(text)
signal pickup(obj_name, resource)

func _ready():		
	res = pickable_obj_resource
	
	sentences.push_back(res.dialogue_line)
	dialogue = Dialogue.new(sentences)
	
	sprite_node = $Sprite
	
	# set up this obj texture
	sprite_node.texture = res.texture
	sprite_node.position = Vector2(res.texture.get_width() / 2 * -1, res.texture.get_height() * -1)
	
	connect("pickup", GameState, "_on_item_pickup")

func _process(delta):
	# pickup / dialogue triggers
	if Input.is_action_just_pressed("player_interact"):
		
		var trigger_area : Area2D  = player_node.get_node("TriggerArea")
		
		if trigger_area.overlaps_area($TriggerArea) and !player_node.is_holding_item:			
			if !res.dialogue_line.empty():
				dialogue_node.emit_signal("dialogue_interact", dialogue, null)
			emit_signal("pickup", res)
			player_node.is_holding_item = true
			queue_free()
			

