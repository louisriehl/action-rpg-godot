extends Node2D

var pickupEffect = preload("res://Effects/PickupEffect.tscn")

onready var particles = $Particles2D
onready var explosion = $Explosion

func _ready():
	explosion.emitting = true
	particles.emitting = true
	
func _on_Area2D_body_entered(body):
	PlayerStats.keys += 1
	queue_free()
	var effect = pickupEffect.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
