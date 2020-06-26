extends CanvasLayer

onready var transitionPlayer = $AnimationPlayer

func change_scene(next_scene : PackedScene):
	transitionPlayer.play("TransitionOut")
	yield(transitionPlayer, "animation_finished")
	assert(get_tree().change_scene_to( next_scene) == OK)
	transitionPlayer.play("TransitionIn")
	yield(transitionPlayer, "animation_finished")
