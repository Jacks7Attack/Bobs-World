extends Control

var time: float = 5.0


# Called when the node enters the scene tree for the first time.

func _input(_event):
	if Input.is_action_just_pressed("controls"):
		# Whenever the player opens the controls, free the popup from memory.
		queue_free()

func _ready():
	# Gets the global script and sees if the player has been in the menu yet, if not, shows the popup.
	if !global.hasPlayedMenu:
		global.hasPlayedMenu = true
		await get_tree().create_timer(time).timeout
		# Loop through various nodes and set the modulate, I felt like doing something more cool and less time-
		# consuming than settings a thousand refrences to objects.
		for i: Control in get_children():
			var tween = get_tree().create_tween()
			var color2 = i.modulate
			color2.a = 0.0
			tween.tween_property(i, "modulate", color2, 2.0)
