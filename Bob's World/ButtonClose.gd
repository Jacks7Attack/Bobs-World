extends Button

@onready var audio = $AudioStreamPlayer

func _ready():
	if global.closedNotification == true:
		get_parent().queue_free()
	global.closedNotification = true

func _pressed():
	get_parent().visible = false
	audio.play()
	await audio.finished
	get_parent().queue_free()
