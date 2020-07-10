extends Node2D

onready var player = $YSort/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_spawns = get_node_or_null("PlayerSpawns")
	assert(player_spawns != null)
	assert(player != null)
	if PlayerStats.previous_level != "":
		var player_spawn = player_spawns.get_node(PlayerStats.previous_level)
		if player_spawn != null:
			player.global_position = player_spawn.global_position
