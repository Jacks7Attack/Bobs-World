extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	var tween = get_tree().create_tween()
	var color2 = Color(0, 0, 0, 0)
	tween.tween_property(self, "modulate", color2, 2.0)
	await tween.finished
	queue_free()
