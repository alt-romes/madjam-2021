extends Node

var carried_item : PickableObjData
var is_talking = false

signal picked_item_ui

func _ready():
	carried_item = null
	pass

func _on_item_pickup(resource : PickableObjData):
	carried_item = resource
