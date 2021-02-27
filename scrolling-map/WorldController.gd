extends Node

onready var camera = get_node("Player/Camera2D")

var levels : Array = [] # Level[]
var current_level : Level
var current_level_index : int = 0


# Level size should be a constant for all levels (x, y)
# (All levels should have the same width and height per room)
export var level_size : PoolIntArray = [1440, 1280]

func _ready():
	
	# Levels must be organized in the tree by the correct order
	for level in get_node("Levels").get_children():
		level.hide()
		levels.append(level)
	
	current_level = levels[current_level_index]
	current_level.show()
	
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
	# Load the next or the same level next to the exit
	
	# Calculate player offset in the level
	var xoffset = int(camera.position.x) % level_size[0]
	var yoffset = int(camera.position.y) % level_size[1]
	
	var current_level_centerx = camera.position.x - xoffset
	var current_level_centery = camera.position.y - yoffset
	
	var next_level_center = Vector2(current_level_centerx, current_level_centery)
	
	if side == "left":
		next_level_center[0] -= level_size[0]
	elif side == "top":
		next_level_center[1] -= level_size[1]
	elif side == "bottom":
		next_level_center[1] += level_size[1]
	elif side == "right":
		next_level_center[0] += level_size[0]
	
	if current_level.is_finished():
		current_level_index += 1
		current_level = levels[current_level_index]
	# else don't change the level
	
	var level_at_exit = current_level.duplicate()
	
	level_at_exit.position = next_level_center
	level_at_exit.show()
	get_node("Levels").add_child(level_at_exit)
