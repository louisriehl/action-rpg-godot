extends StaticBody2D

var dialogueLoader = load("res://Dialogue/DialogueLoader.gd").new()

export var dialogue_path : String
var player_in_activation_zone : bool = false

func _ready():
	var dialogue = dialogueLoader.load_dialogue(dialogue_path)
	print(dialogue)
	
func _physics_process(_delta):
	if player_in_activation_zone and Input.is_action_just_pressed("ui_accept"):
		print( "in activation zone and activated!" )

func _on_ActivationZone_body_entered(_body):
	player_in_activation_zone = true

func _on_ActivationZone_body_exited(_body):
	player_in_activation_zone = false
