extends Camera2D

# The camera used to be inside the player, but I wanted to make sure I could easily make simple "cutscenes", so I opted to put it in the level scene instead.
@onready var postProcess := $PostProcess

@export var snap = false

var player = null
var followPlayer = true

func _ready():
	var config = postProcess.configuration as PostProcessingConfiguration
	config.ScreenShakePower = 0.0
	config.CircularWavesAmplitude = 0.0
	# Get the player, done like this instead of @onready because I couldn't find the path for the player.
	for i in get_tree().root.get_children():
		for i2 in i.get_children():
			if i2.is_in_group("Player"):
				player = i2
				
	if snap: position_smoothing_enabled = false
	
	if followPlayer == true:
		# Stop camera smoothing whenever getting the camera to the initial player position.
		
		if position_smoothing_enabled == true:
			var lastSpeed = position_smoothing_speed
			position_smoothing_speed = 0.0
			position = player.position
			position_smoothing_speed = lastSpeed
		else:
			position = player.position

# Camera smoothing is unneccesary due to a camera option, so just set position whenever doing cutscenes or changing position.
func _process(_delta):
	if followPlayer == true:
		position = player.position
		rotation = player.rotation
