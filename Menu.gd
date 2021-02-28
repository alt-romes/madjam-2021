extends MarginContainer

const first_scene = preload("res://ContainerScene.tscn")



func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
					 
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			get_parent().add_child(first_scene.instance())
			queue_free()

