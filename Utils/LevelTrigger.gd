extends Area2D

export (String) var next_scene

func _on_LevelTrigger_body_entered(body):
	SceneChanger.change_scene(next_scene)
