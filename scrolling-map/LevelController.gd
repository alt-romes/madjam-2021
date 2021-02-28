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

func is_finished():
	return false

# Item gets dropped into the current field
func item_dropped(item : PickableObj):
	get_node("YSort/Objects").add_child(item)
