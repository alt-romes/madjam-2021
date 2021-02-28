extends Label

func _ready():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_scale",
		Vector2(1, 1), Vector2(.5, .5), 1,
		Tween.TRANS_BACK, Tween.TRANS_LINEAR)
	tween.start()
