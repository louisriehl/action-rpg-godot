extends Control
class_name DialogueBox 

var dialogue = {
	"0": {"dialogue":"This is the first test dialogue line..."},
	"1": {"dialogue":"This is the second line!"}
}

onready var timer = $Timer
var page = 0
onready var panel = $Panel
onready var dialogueBox = $Panel/HBoxContainer/Dialogue

func _ready():
	dialogueBox.text = dialogue[str(page)]["dialogue"]
	
func _process(delta):
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
	
func _on_Timer_timeout():
	dialogueBox.visible_characters += 1
