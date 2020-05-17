extends Control

enum {
	STARTED,
	STOPPED
}

onready var timer = $Timer
onready var panel = $Panel
onready var dialogueBox = $Panel/HBoxContainer/Dialogue

var page = 0
var state = STOPPED
var dialogue = {}
	
func _process(delta):
	if state == STARTED:
		if Input.is_action_just_pressed("ui_accept"):
			if dialogue_line_not_completed():
				dialogueBox.visible_characters = dialogue[str(page)]["dialogue"].length()
			else: 
				page += 1
				if page >= dialogue.size():
					panel.visible = false
				else:
					nextPage()

func nextPage() -> void:
	dialogueBox.visible_characters = 0
	dialogueBox.text = dialogue[str(page)]["dialogue"]
	
func dialogue_line_not_completed() -> bool:
	return dialogueBox.visible_characters < dialogue[str(page)]["dialogue"].length()
	
func _dialogue_Started( dialogue ):
	self.visible = true
	print(dialogue)
	
func _on_Timer_timeout():
	dialogueBox.visible_characters += 1
