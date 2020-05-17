extends StaticBody2D

onready var dialogueLoader = $DialogueLoader

export var dialogue_path : String
var dialogue = "no dialogue yet defined"
var player_in_activation_zone : bool = false
var dialogueBox

signal dialogueStarted

func _ready():
	# feels like a hack... what if the path changes?
	dialogueBox = get_tree().current_scene.get_node("/root/World/UI/DialogueBox")
	dialogue = dialogueLoader.load_dialogue(dialogue_path)
	connect( "dialogueStarted", dialogueBox, "_dialogue_Started" )
	
func _physics_process(_delta):
	if player_in_activation_zone and Input.is_action_just_pressed("ui_accept"):
		emit_signal("dialogueStarted", dialogue)

func _on_ActivationZone_body_entered(_body):
	player_in_activation_zone = true

func _on_ActivationZone_body_exited(_body):
	player_in_activation_zone = false
