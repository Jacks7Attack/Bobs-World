extends Control

# Set up some vars and object references.
@onready var text = $TextEdit
@onready var icon = $Icon
@onready var camera = $"../.."
@onready var background = $Background
@onready var audio = $AudioStreamPlayer
var chatting = false
var offsetBack
var tween
var offsetIcon
var time
var defaultTime
var offsetText
var timesAmount = 2

func change(texture, string, timePerLetter):
	chatting = true
	# Get the number of how many letters there are in the string to do some math.
	var number = 0
	for i in string:
		number += 1
	# Sets time, that way some math can be done to make the chatting noises play at the right speed.
	time = timePerLetter * timesAmount
	# Default time is what it counts down from in _process.
	defaultTime = timePerLetter * timesAmount
	# Change time per letter to the tween
	timePerLetter = timePerLetter * number
	# Load the texture, that way it can be used as an image.
	texture = load(texture)
	# Reset the text to make the tween work right.
	text.text = ""
	# Set the tween and texture, wait for it to finish, then remove the chatting tag.
	var tween2 = get_tree().create_tween()
	tween = tween2
	tween2.tween_property(text, "text", string, timePerLetter)
	icon.set_texture(texture)
	await tween2.finished
	chatting = false

func _process(delta):
	# Plays the audio if the player is chatting.
	if chatting == true:
		time -= delta
		if time <= 0: 
			time = defaultTime
			audio.play()
