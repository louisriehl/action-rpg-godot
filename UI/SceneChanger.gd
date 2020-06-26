extends CanvasLayer

onready var transitionPlayer = $AnimationPlayer

func change_scene(next_scene : PackedScene):
	transitionPlayer.play("TransitionOut")
	yield(transitionPlayer, "animation_finished")
	assert(get_tree().change_scene_to( next_scene) == OK)
	transitionPlayer.play("TransitionIn")
	yield(transitionPlayer, "animation_finished")
	
func reload_scene():
	transitionPlayer.play("TransitionOut")
	yield(transitionPlayer, "animation_finished")
	get_tree().reload_current_scene()
	transitionPlayer.play("TransitionIn")
	yield(transitionPlayer, "animation_finished")
