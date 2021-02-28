extends Node

onready var player = get_node("Player")
onready var camera = get_node("Player/Camera2D")

var levels : Array = [] # Level[]
var current_level : Level
var current_level_index : int = 0
var current_level_center_index : Vector2 = Vector2(0, 0) # Player starts in 0, 0 tile
var levels_centers_drawn : Array = [] # Vector2[]

# Level size should be a constant for all levels (x, y)
# (All levels should have the same width and height per room)
export var level_size : PoolIntArray = [480, 336]

func _ready():
	
	# Brick because the build will have no scrolling
	return true
	
	# Levels must be organized in the tree by the correct order
	for level in get_node("Levels").get_children():
		level.hide()
		#level.set_process(false)
		levels.append(level)
	
	current_level = levels[current_level_index]
	current_level.show()
	#current_level.set_process(true)
	levels_centers_drawn.append(Vector2(0, 0))
	
	_load_level_borders() # This will also be called whenever the level changes
						  # and when the win state changes

func _process(delta):
	# Brick to disable scrolling
	return true
	
	# Every frame check if player "changed" level
	
	var current_level_centerx = int(player.position.x/level_size[0])
	var current_level_centery = int(player.position.y/level_size[1])
	
	# When center of the next level is reached, change current_level
	if current_level_centerx != current_level_center_index.x || current_level_centery != current_level_center_index.y:
		# Gets called every time the player crosses the border -> and will draw ahead at the next exit
		
		
		# Before moving the center, add a fake YSort here
		# Don't worry about clearing them, the actual Y Sort should always be on top...
		current_level.get_node("FakeYSorts").add_child(current_level.get_node("YSort").duplicate())
		
		_change_current_level(Vector2(current_level_centerx, current_level_centery))


# Private functions

func _change_current_level(new_center : Vector2):
	print("Change level")
	current_level_center_index = new_center
	
	# Just changed into a new center, so move the actual YSort to here
	current_level.get_node("YSort").position = Vector2(current_level_center_index[0]*level_size[0], current_level_center_index[1]*level_size[1])
	
	# If the level is finished, the new level will be drawn at the exit
	# TODO: to change level
	if current_level.is_finished():
		current_level_index += 1
		current_level = levels[current_level_index]
		current_level.show()
		#current_level.set_process(true)
		levels_centers_drawn.empty() # No levels centers drawn for this one yet
	# else don't change the level
	
	# Load next borders for continuity (next and previous level ysort and tilemap)
	_load_level_borders()

func _load_level_borders():
	var borders = current_level.borders
	#print(borders)
	for side in borders:
		if borders[side] == Level.BorderType.LIMIT_SIDE:
			_limit_camera(side)
		else:
			_reset_camera_limit(side)
			
		if borders[side] == Level.BorderType.EXIT_SIDE:
			_load_exit(side)

func _limit_camera(side : String):
	# Side is : left | right | top | bottom
	var limit_val = null
	if side == "left":
		limit_val = -current_level_center_index[0]*level_size[0]
	elif side == "right":
		limit_val = current_level_center_index[0]*level_size[0] + level_size[0]
	elif side == "top":
		limit_val = -current_level_center_index[1]*level_size[1]
	elif side == "bottom":
		limit_val = current_level_center_index[1]*level_size[1] + level_size[1] + 24
	
	#print("Side: ", side, " Val ", limit_val)
	
	camera["limit_"+side] = limit_val

func _reset_camera_limit(side : String):
	var limit_val = null
	if side == "left":
		limit_val = -10000000
	elif side == "right":
		limit_val = 10000000
	elif side == "top":
		limit_val = -10000000
	elif side == "bottom":
		limit_val = 10000000
	
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
	
	
	if !_has_drawn_level(next_level_center):
		# Tilemap
		var level_at_exit = current_level.get_node("TileMap").duplicate()
		level_at_exit.position = next_level_center
		level_at_exit.show()
		
		#print(level_at_exit.position)
		
		current_level.get_node("AdditionalTilemaps").add_child(level_at_exit)
		
		
		
		levels_centers_drawn.append(next_level_center)
		
	# Even if has drawn, must change 

# Has drawn the same level in the same position ?
func _has_drawn_level(level_center : Vector2) -> bool:
	for l in levels_centers_drawn:
		if l.x == level_center.x && l.y == level_center.y:
			return true
	return false


# Public methods

func item_dropped(item : PickableObj):
	levels[current_level_index].item_dropped(item)
