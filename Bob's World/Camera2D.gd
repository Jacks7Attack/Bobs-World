extends Camera2D

@onready var rect = $ColorRect
var transparent = Color(0.0, 0.0, 0.0, 0.0)
var visibleColor = Color(0.0, 0.0, 0.0, 1.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	rect.visible = true
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(rect, "modulate", transparent, 2.0)
	


func fadeOut():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(rect, "modulate", visibleColor, 2.0)
	

