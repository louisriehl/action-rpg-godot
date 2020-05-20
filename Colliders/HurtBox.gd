extends Area2D

const hitEffect = preload("res://Effects/HitEffect.tscn")
var invincible = false setget set_invincible
onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

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

func create_hit_effect( x_offset=0, y_offset=0 ):
	var effect : AnimatedSprite = hitEffect.instance()
	effect.offset.x = x_offset
	effect.offset.y = y_offset
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

# by using self.invincible, we force use of the setter rather than bypass
func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invincibility_started():
	collisionShape.set_deferred("disabled", true)

func _on_HurtBox_invincibility_ended():
	collisionShape.set_deferred("disabled", false)
 
