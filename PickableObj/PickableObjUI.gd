extends CanvasLayer

onready var texture_holder : TextureRect = $Control/TextureRect
onready var name_label : Label = $Control/Label

var current_item : PickableObjData

func _ready():
	pass
	
func _process(delta):
	
	if current_item != GameState.carried_item:
		current_item = GameState.carried_item
		
		# update the ui texture
		if current_item != null:
			texture_holder.texture = current_item.texture
			name_label.text = current_item.name
		else:
			texture_holder.texture = null
			name_label.text = ""
		
