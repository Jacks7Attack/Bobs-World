extends Node2D

@onready var friendsSpawns := $"Friend Spawns"
@onready var friendsSpawn1 := $"Friend Spawns/Friend Spawn 1"
@onready var friendsSpawn2 := $"Friend Spawns/Friend Spawn 2"
@onready var friendsSpawn3 := $"Friend Spawns/Friend Spawn 3"
@onready var friendsSpawn4 := $"Friend Spawns/Friend Spawn 4"

# Called when the node enters the scene tree for the first time.
func _ready():
	var currentFriends = global.friends
	var number = 0
	for i in currentFriends:
		if i != null:
			var object := load(i)
			object.instantiate()
			if number == 0: object.position = friendsSpawn1.position
			if number == 1: object.position = friendsSpawn2.position
			if number == 2: object.position = friendsSpawn3.position
			if number == 3: object.position = friendsSpawn4.position
			number += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
