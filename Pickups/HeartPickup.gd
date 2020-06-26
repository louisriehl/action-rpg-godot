extends Node2D

onready var particles = $Particles2D
onready var explosion = $Explosion

func _ready():
	explosion.emitting = true
	particles.emitting = true
	
func _on_Area2D_body_entered(body):
	PlayerStats.set_max_health( PlayerStats.max_health + 1)
	PlayerStats.restore_all_health()
	queue_free()
