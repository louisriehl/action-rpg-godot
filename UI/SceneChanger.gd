extends CanvasLayer

onready var transitionPlayer = $AnimationPlayer

func change_scene(next_scene : String, previous_scene : String):
	transitionPlayer.play("TransitionOut")
	yield(transitionPlayer, "animation_finished")
	PlayerStats.previous_level = previous_scene
	assert(get_tree().change_scene( next_scene) == OK)
	transitionPlayer.play("TransitionIn")
	yield(transitionPlayer, "animation_finished")
	
func reload_scene():
	transitionPlayer.play("TransitionOut")
	yield(transitionPlayer, "animation_finished")
	get_tree().reload_current_scene()
	PlayerStats.restore_all_health()
	transitionPlayer.play("TransitionIn")
	yield(transitionPlayer, "animation_finished")
