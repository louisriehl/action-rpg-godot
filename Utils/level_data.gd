extends Node

var level_data : Array = []

func is_arena_cleared(arena_name):
	return level_data.has(arena_name)
	
func set_arena_cleared(arena_name):
	level_data.append(arena_name)
