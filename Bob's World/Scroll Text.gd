extends Control

@onready var camera = $"../Camera2D"

@export var globalTargetPos = Vector2(0.0, 0.0)
@export var time = 15.0


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position", globalTargetPos, time)
	
	await tween.finished
	camera.fadeOut()
	await get_tree().create_timer(2.0).timeout
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
	
