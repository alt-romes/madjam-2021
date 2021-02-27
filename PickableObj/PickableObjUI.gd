extends CanvasLayer

onready var control : Control = $Control
onready var texture_holder : TextureRect = $Control/Box/MarginContainer/VBoxContainer/HBoxContainer/TextureRect
onready var name_label : Label = $Control/Box/MarginContainer/VBoxContainer/Label

var current_item : PickableObjData

func _ready():
	control.visible = false
	
func _process(delta):
	
	if current_item != GameState.carried_item:
		current_item = GameState.carried_item
		
		# update the ui texture
		if current_item != null:
			control.visible = true
			texture_holder.texture = current_item.texture
			name_label.text = current_item.name
		else:
			control.visible = false
			texture_holder.texture = null
			name_label.text = ""
		
