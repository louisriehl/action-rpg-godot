extends Node2D

onready var label = $Control/Label
onready var modulateTween = $ModulateTween

export var fade_time : float = 1
export var sign_text : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	label.modulate = Color(1, 1, 1, 0)
	label.set_text(sign_text)

func _on_DetectionArea_body_entered(body):
	modulateTween.interpolate_property( 
		label,
		"modulate",
		label.get_modulate(), 
		Color(1, 1, 1, 1),
		fade_time,
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT)
		
	modulateTween.start()

func _on_DetectionArea_body_exited(body):
	modulateTween.interpolate_property( 
		label,
		"modulate",
		label.get_modulate(), 
		Color(1, 1, 1, 0),
		fade_time,
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT)
		
	modulateTween.start()
