extends Node

onready var player = get_node("Player")
onready var camera = get_node("Player/Camera2D")

var levels : Array = [] # Level[]
var current_level : Level
var current_level_index : int = 0
var current_level_center_index : Vector2 = Vector2(0, 0) # Player starts in 0, 0 tile
var levels_drawn : Array = [] # Node[]

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
	levels_drawn.append(current_level)
	
	_load_level_borders() # This will also be called whenever the level changes
						  # and when the win state changes

func _process(delta):
	# Every frame check if player "changed" level
	
	var current_level_centerx = int(player.position.x/level_size[0])
	var current_level_centery = int(player.position.y/level_size[1])
	
	# When center of the next level is reached, change current_level
	if current_level_centerx != current_level_center_index.x || current_level_centery != current_level_center_index.y:
		_change_current_level(Vector2(current_level_centerx, current_level_centery))


# Private functions

func _change_current_level(new_center : Vector2):
	print("Display more level")
	current_level_center_index = new_center
	_load_level_borders()

func _load_level_borders():
	var borders = current_level.borders
	print(borders)
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
	
	var next_level_center = Vector2(current_level_center_index[0]*level_size[0], current_level_center_index[1]*level_size[1])
	
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
	
	if !_has_drawn_level(next_level_center):
		var level_at_exit = current_level.duplicate()
		level_at_exit.position = next_level_center
		level_at_exit.show()
		
		print(level_at_exit.position)
		
		get_node("Levels").add_child(level_at_exit)
		
		levels_drawn.append(level_at_exit)

# Has drawn the same level in the same position ?
func _has_drawn_level(level_center : Vector2) -> bool:
	for l in levels_drawn:
		if l.level_id == current_level.level_id && l.position.x == level_center.x && l.position.y == level_center.y:
			return true
	return false
