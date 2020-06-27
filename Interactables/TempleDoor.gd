extends Node2D

onready var animator = $Sprite/AnimationPlayer2
var total_locks = 3

func _on_UnlockZone_body_entered(body):
	if PlayerStats.keys == 0:
		print("no keys")
		pass
	
	var keys_available = PlayerStats.keys
	
	for lock in get_node("Locks").get_children():
		if keys_available > 0:
			var animator : AnimationPlayer = lock.get_child(0)
			keys_available -= 1
			PlayerStats.keys -= 1
			animator.play("Disappear")
			yield(animator, "animation_finished")
			lock.queue_free()
			total_locks -=1
		
	if total_locks == 0:
		animator.play("Disappear")
		yield(animator, "animation_finished")
		queue_free()
