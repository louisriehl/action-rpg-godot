extends KinematicBody2D

const hitEffect = preload("res://Effects/HitEffect.tscn")
export var acceleration : float = 300
export var max_speed : float  = 100

var velocity : Vector2 = Vector2.ZERO
var target : Vector2

func _ready():
	# test to simulate real behavior where we'll pass this field in
	var player : KinematicBody2D = get_tree().current_scene.get_node("/root/ProjectileTest/Player")
	# when instanced, rotate object to orient towards target
	target = player.global_position
	look_at(target)

func _physics_process(delta):
	# velocity is constant forward movement
	velocity = Vector2(max_speed * delta, 0).rotated(rotation)
	var collide = move_and_collide(velocity)
	
	# if colliding with non-player target, self-destruct with effect
	if collide:
		detonate()

func _on_HitBox_area_entered(area):
	queue_free()

func detonate():
	create_hit_effect()
	queue_free()
	
func create_hit_effect():
	var effect = hitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
