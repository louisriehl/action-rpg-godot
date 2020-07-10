extends Area2D

export (String) var next_scene = ""
export (Vector2) var leave_direction = Vector2.ZERO

var current_level : String

func _ready():
	current_level = get_parent().name

func _on_LevelTrigger_body_entered(body):
	SceneChanger.change_scene(next_scene, current_level, leave_direction)
