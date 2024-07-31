extends Button

@onready var background = $Background
@onready var beginModulate = background.modulate
@onready var audio = $AudioStreamPlayer
@onready var menu = $"../.."

@export var divideAmountForHover = 1.3
var player

func _ready():
	for i in get_tree().root.get_children():
		for i2 in i.get_children():
			if i2.is_in_group("Player"):
				player = i2
				
func _pressed():
	menu.exitMenu()
	audio.play()

func _physics_process(_delta):
	if is_hovered():
		var mod = background.modulate
		
		mod.r = beginModulate.r / divideAmountForHover
		mod.g = beginModulate.g / divideAmountForHover
		mod.b = beginModulate.b / divideAmountForHover
		
		background.modulate = mod

	else:
		background.modulate = beginModulate
