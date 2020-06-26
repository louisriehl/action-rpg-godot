extends Node2D

func _on_Area2D_body_entered(body):
	PlayerStats.set_max_health( PlayerStats.max_health + 1)
	PlayerStats.restore_all_health()
	queue_free()
