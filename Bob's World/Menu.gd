extends Control

@onready var postProcess = $"../../PostProcess"
@onready var config = postProcess.configuration as PostProcessingConfiguration
@onready var optionsMenu = $Buttons/OptionsMenu
@onready var chat = $"../Dialogue"

@export var menuBlurAmount = 0.625
var inMenu = false
var player
var chatVisible = false
var lastTimeScale
var pressed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	config.L_O_D = 0.0
	
	for i in get_tree().root.get_children():
		for i2 in i.get_children():
			if i2.is_in_group("Player"):
				player = i2

func enterMenu():
	chatVisible = chat.visible
	
	chat.visible = false
	pressed = true
	inMenu = true
	
	config.L_O_D = menuBlurAmount
	lastTimeScale = Engine.time_scale
		
	if player: player.deafenMusicNow()
		
	Engine.time_scale = 0.0
	visible = true

func exitMenu():
	optionsMenu.visible = false
	chat.visible = chatVisible
	
	pressed = true
	inMenu = false
	
	config.L_O_D = 0.0
	
	if player and !chat.visible: player.normalizeMusicNow()
	elif player and chat.visible: player.deafenMusic()
		
	Engine.time_scale = lastTimeScale
	visible = false

func _input(_event):
	pressed = false
	
	if Input.is_action_just_pressed("menu") and player.canEnterMenu and !inMenu and !pressed:
		enterMenu()
		
	
	if Input.is_action_just_pressed("menu") and inMenu and !pressed:
		exitMenu()
	
	pressed = false
		
		
		
