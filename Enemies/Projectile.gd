extends KinematicBody2D

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

func _physics_process(delta) -> void:
	# velocity is constant forward movement
	velocity = Vector2(max_speed * delta, 0).rotated(rotation)
	var collide = move_and_collide(velocity)
	
	if collide:
		queue_free()

func _on_HitBox_area_entered(area):
	queue_free()
