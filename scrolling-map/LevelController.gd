extends Node

class_name Level

# The borders can be one of the three BorderType enum values (#enums aren't types)
# limit stops the camera at that border
# exit is where the player will go through to get to the next level
# enter is where from he'll enter from the previous level
# Limit = 0, Enter = 1, Exit = 2
enum BorderType {LIMIT_SIDE, ENTER_SIDE, EXIT_SIDE}
export var left_border : int
export var right_border : int
export var top_border : int
export var bottom_border : int

export var level_id : int

var borders : Dictionary

func _ready():
	borders = {
		"left": left_border,
		"right": right_border,
		"top": top_border,
		"bottom": bottom_border
	}

func _process(delta):	
	print(is_finished())

func is_finished():
	
	var npc_collection = get_node("YSort/NPCCollection").get_children()
	
	var completed_count = 0
	if npc_collection.size() > 0:
		for npc in npc_collection:
			if npc.objective_completed:
				completed_count += 1				
		if completed_count == npc_collection.size():
			return true
	
	return false
	

# Item gets dropped into the current field
func item_dropped(item : PickableObj):
	get_node("YSort/Objects").add_child(item)
