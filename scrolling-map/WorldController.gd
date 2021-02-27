extends Node

onready var camera = get_node("Player/Camera2D")

var levels : Array = [] # Level[]
var current_level : Level

# Level size should be a constant for all levels (x, y)
# (All levels should have the same width and height per room)
export var level_size : PoolIntArray = [1440, 1280]

func _ready():
	
	# Use group node and for over the children to add them to the levels array
	levels.append(get_node("Level"))
	
	current_level = levels[0]
	
	_load_level_borders() # This will also be called whenever the level changes
						  # and when the win state changes


# Private functions

func _load_level_borders():
	var borders = current_level.borders
	for side in borders:
		if borders[side] == Level.BorderType.LIMIT_SIDE:
			_limit_camera(side)
		elif borders[side] == Level.BorderType.EXIT_SIDE:
			_load_exit(side)

func _limit_camera(side : String):
	# Side is : left | right | top | bottom
	var limit_val = null
	if side == "left":
		limit_val = -level_size[0]/2
	elif side == "right":
		limit_val = level_size[0]/2
	elif side == "top":
		limit_val = -level_size[1]/2
	elif side == "bottom":
		limit_val = level_size[1]/2
	
	camera["limit_"+side] = limit_val
	
func _load_exit(side : String):
	pass
