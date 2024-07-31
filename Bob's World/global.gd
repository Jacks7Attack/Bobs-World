extends Node

var hasPlayedMenu = false
var enemies = []
var closedNotification = false
var friends = ["res://bobRPG"]
var friendPath2 = "user://friend2"
var friendPath3 = "user://friend3"
var friendPath4 = "user://friend4"

func _ready():
	loadFriends()

func loadFriends():
	if FileAccess.file_exists(friendPath2) and FileAccess.file_exists(friendPath3) and FileAccess.file_exists(friendPath4):
		var file2 = FileAccess.open(friendPath2, FileAccess.READ)
		var file3 = FileAccess.open(friendPath3, FileAccess.READ)
		var file4 = FileAccess.open(friendPath4, FileAccess.READ)
		
		if file2.get_line() != null: friends.append(file2.get_line())
		if file3.get_line() != null: friends.append(file3.get_line())
		if file4.get_line() != null: friends.append(file4.get_line())

func saveFriends():
	var file2 = FileAccess.open(friendPath2, FileAccess.WRITE)
	var file3 = FileAccess.open(friendPath3, FileAccess.WRITE)
	var file4 = FileAccess.open(friendPath4, FileAccess.WRITE)
	
	if friends[1] != null: file2.store_line(friends[1])
	if friends[2] != null: file3.store_line(friends[2])
	if friends[3] != null: file4.store_line(friends[3])
	
