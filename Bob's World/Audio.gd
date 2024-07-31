extends Node2D

var random = randf()
@export var time = 7.5

func _ready():
	await get_tree().create_timer(time).timeout
	while true:
		print(random)
		var firstNumber = 0.0
		for i: AudioStreamPlayer in get_children():
			firstNumber += 1.0
		var instance
		firstNumber = 1.0 / firstNumber
		var secondNumber = 1.0
		for i: AudioStreamPlayer in get_children():
			if random < firstNumber * secondNumber:
				i.play()
				await i.finished
				instance = i
			secondNumber += 1.0
		if instance != null: await get_tree().create_timer(time).timeout
		random = randf()
	
