extends Sprite2D

var waitTime = 2
var tweenTime = 1.4

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func _ready():
	var tween = get_tree().create_tween()
	var color = Color(1, 1, 1, 1)
	tween.tween_property(self, "modulate", color, tweenTime)
	await tween.finished
	await get_tree().create_timer(waitTime).timeout
	tween = get_tree().create_tween()
	color = Color(1, 1, 1, 0)
	tween.tween_property(self, "modulate", color, tweenTime)
	await tween.finished
	get_tree().change_scene_to_file("res://main menu.tscn")
