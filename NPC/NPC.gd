extends Node2D

export var player_node_path : NodePath
export var sprite_img : Texture
export var npc_name : String
export var dialogue_list : PoolStringArray

onready var sprite_node = $Sprite
onready var player_node = get_node(player_node_path)

var dialogue_index : int = 0

signal set_dialogue(text)

func _ready():	
	sprite_node.texture = sprite_img
	sprite_node.position = Vector2(sprite_img.get_width() / 2 * -1, sprite_img.get_height() * -1)

func _process(delta):
	
	if Input.is_action_just_pressed("ui_accept") and dialogue_list.size() > 0:		
		var trigger_area : Area2D  = player_node.get_node("TriggerArea")		
		if trigger_area.overlaps_area($TriggerArea):
			say_dialogue()			
		

func say_dialogue() -> void:
	emit_signal("set_dialogue", dialogue_list[dialogue_index])
	print(dialogue_list[dialogue_index])
	dialogue_index = (dialogue_index + 1) % dialogue_list.size()
	
