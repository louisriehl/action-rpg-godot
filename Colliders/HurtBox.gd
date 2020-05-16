extends Area2D

const hitEffect = preload("res://Effects/HitEffect.tscn")
var invincible = false setget set_invincible
onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value : bool):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration : float):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = hitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

# by using self.invincible, we force use of the setter rather than bypass
func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invincibility_started():
	set_deferred("monitorable", false)

func _on_HurtBox_invincibility_ended():
	set_deferred("monitorable", true)
 
