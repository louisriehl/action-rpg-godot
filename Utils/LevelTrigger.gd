extends Area2D

export var next_scene : PackedScene

func _on_LevelTrigger_body_entered(body):
	SceneChanger.change_scene(next_scene)
