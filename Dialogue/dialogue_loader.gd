extends Node

export (String, FILE, "*.json") var dialogue_path : String

func load_dialogue(dialogue_path) -> Dictionary:
	var file = File.new()
	var dialogue = {}
	
	assert(file.file_exists(dialogue_path))
	file.open(dialogue_path, File.READ)
	var text = file.get_as_text()
	dialogue = parse_json(text)
	
	file.close()
	
	assert(dialogue.size() > 0 )
	return dialogue
