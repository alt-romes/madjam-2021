extends Node

onready var dialogue_box = find_node("Control/Box")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_box.visible = false

# Events

signal dialogue_interact



func _on_Dialogue_dialogue_interact():
	pass # Replace with function body.
