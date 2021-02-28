extends Node2D

enum objective_type { pickable, pushable }

export var sprite_img_idle : Texture
export var sprite_img_talk : Texture
export var voice : AudioStream
export var npc_name : String
export var dialogue_list_pre_objective : PoolStringArray
export var dialogue_list_after_objective : PoolStringArray
export var pushable_objective_obj_nodepath : NodePath
export var pickable_objective_obj_resource : Resource
export var npc_objective_type = objective_type.pickable

var dialogue_list_wrong_objective : PoolStringArray

onready var sprite_node = $Sprite
onready var main_node = get_node("../../../../../") # p: YScroll, p: Level0, p: Levels, p: Main
onready var player_node = main_node.get_node("Player")
onready var dialogue_node = get_tree().root.get_node("Control/CanvasLayer/Dialogue")

var dialogue : Dialogue
var pushable_objective_obj
var pickable_objective_obj : PickableObjData
var rng

onready var objective_completed = false

signal set_dialogue(text)

func _ready():	
	sprite_node.texture = sprite_img_idle
	sprite_node.position = Vector2(sprite_img_idle.get_width() / 2 * -1, sprite_img_idle.get_height() * -1)
	dialogue = Dialogue.new(dialogue_list_pre_objective)
	
	dialogue_list_wrong_objective = PoolStringArray([npc_name + ": " + "You're such a weirdo omg", npc_name + ": " + "What is this Anon?", npc_name + ": " + "What should I do with this!?"])
	
	if npc_objective_type == objective_type.pushable:
		pushable_objective_obj = get_node(pushable_objective_obj_nodepath)
	elif npc_objective_type == objective_type.pickable:
		pickable_objective_obj = pickable_objective_obj_resource
		
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
func _process(delta):
	
	if !GameState.is_talking:
			sprite_node.texture = sprite_img_idle			
	
	if Input.is_action_just_pressed("player_interact") and dialogue.sentences.size() > 0:		
		
		var trigger_area : Area2D  = player_node.get_node("TriggerArea")
				
		if trigger_area.overlaps_area($TriggerArea):
			
			if npc_objective_type == objective_type.pushable:			
				objective_completed = pushable_objective_obj.in_place
				print(pushable_objective_obj.in_place)
			elif npc_objective_type == objective_type.pickable:
				if player_node.is_holding_item:
					if GameState.carried_item == pickable_objective_obj:
						objective_completed = true
				
			if !objective_completed:
				if npc_objective_type == objective_type.pickable and player_node.is_holding_item and GameState.carried_item != pickable_objective_obj:
					var index = rng.randi_range(0, dialogue_list_wrong_objective.size() - 1)
					dialogue = Dialogue.new([dialogue_list_wrong_objective[index]])
				else:
					dialogue = Dialogue.new(dialogue_list_pre_objective)
			else:
				dialogue = Dialogue.new(dialogue_list_after_objective)

			dialogue_node.emit_signal("dialogue_interact", dialogue, voice)
			sprite_node.texture = sprite_img_talk
			GameState.is_talking = true
	
	
