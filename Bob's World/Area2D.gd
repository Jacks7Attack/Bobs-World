extends Area2D

# 18 chars per line for dialogue.
var player
var inArea = false
var chatting = true
var started = false
var canContinue = false
var canContinue2 = false
var cooldown = false


func _on_body_entered(body):
	if body.is_in_group("Player") and started == false:
		player = body
		inArea = true

func _on_body_exited(body):
	if body.is_in_group("Player") and started == false:
		inArea = false

func _input(_event):
	var pressed = false
	
	if inArea == true and player and Input.is_action_just_pressed("jump") and started == false and pressed == false and canContinue2 == false and cooldown == false:
		player.deafenMusic()
		started = true
		pressed = true
		var chat = player.chat
		chat.change("res://sign.png", "press space to co--ntinue", 0.05)
		chat.visible = true
		await chat.tween.finished
		canContinue = true
		print("finished")
	
	if inArea == true and player and Input.is_action_just_pressed("jump") and started == true and pressed == false and canContinue == true and cooldown == false:
		canContinue = false
		var chat = player.chat
		chat.change("res://sign.png", "thats all, good j--ob", 0.05)
		chat.visible = true
		await chat.tween.finished
		canContinue2 = true
	
	if inArea == true and player and Input.is_action_just_pressed("jump") and started == true and pressed == false and canContinue2 == true and cooldown == false:
		player.normalizeMusic()
		inArea = false
		var chat = player.chat
		chat.visible = false
		canContinue = false
		canContinue2 = false
		started = false
		cooldown = true
		await get_tree().create_timer(1).timeout
		cooldown = false
