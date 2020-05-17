extends Control

enum {
	STARTED,
	STOPPED
}

onready var timer = $DialogueTimer
onready var lockoutTimer = $DialogueLockout
onready var panel = $Panel
onready var dialogueBox = $Panel/HBoxContainer/Dialogue

const DIALOGUE_STRING = "speech"
var dialogue_is_locked = true
var page = 0
var state = STOPPED
var dialogue = {}
	
func _process(delta):
	if state == STARTED:
		dialogueBox.visible_characters += 1
		
		if Input.is_action_just_pressed("ui_accept") and !dialogue_is_locked:
			if dialogue_line_not_completed():
				dialogueBox.visible_characters = dialogue[str(page)][DIALOGUE_STRING].length()
			else: 
				page += 1
				if page >= dialogue.size():
					state = STOPPED
					self.visible = false
				else:
					nextPage()

func nextPage() -> void:
	dialogueBox.visible_characters = 0
	dialogueBox.text = dialogue[str(page)][DIALOGUE_STRING]
	
func dialogue_line_not_completed() -> bool:
	return dialogueBox.visible_characters < dialogue[str(page)][DIALOGUE_STRING].length()
	
func _dialogue_Started( dialogue : Dictionary ) -> void:
	init_dialogue(dialogue)
	
func _on_Timer_timeout():
	dialogueBox.visible_characters += 1
	
func _on_DialogueLockout_timeout():
	self.dialogue_is_locked = false
	
func init_dialogue( dialogue : Dictionary ):
	if state == STOPPED:
		page = 0
		dialogueBox.visible_characters = 0
		self.visible = true
		self.dialogue = dialogue
		self.dialogueBox.text = self.dialogue["0"][DIALOGUE_STRING]
		state = STARTED
		dialogue_is_locked = true
		lockoutTimer.start()
