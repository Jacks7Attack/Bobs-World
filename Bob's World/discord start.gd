extends Node
func _ready():
	DiscordRPC.app_id = 1243273887995793450 # Application ID
	DiscordRPC.details = "being worked on by jack/jacks7attack"
	DiscordRPC.state = "please work rich presence"
	DiscordRPC.large_image = "bobs_world_image"
	DiscordRPC.large_image_text = "will be changed later"
	DiscordRPC.small_image_text = "will also be changed later"

	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"

	DiscordRPC.refresh() # Always refresh after changing the values!
