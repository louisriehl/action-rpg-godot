extends KinematicBody2D

const hitEffect = preload("res://Effects/HitEffect.tscn")
export var acceleration : float = 300
export var max_speed : float  = 100
export var reflectable : bool = true

onready var hitBox = $HitBox

var velocity : Vector2 = Vector2.ZERO
var target : Vector2

# position of entity that spawned projectile (used in reflection)
var spawner : Vector2

const CollisionMasks = {
	"PlayerHurtBox": 3,
	"PlayerProjectile": 9,
}

func _ready():
	look_at(target)

func _physics_process(delta):
	# velocity is constant forward movement
	velocity = Vector2(max_speed * delta, 0).rotated(rotation)
	var collide = move_and_collide(velocity)
	
	# if colliding with non-player target, self-destruct with effect
	if collide:
		detonate()

func _on_HitBox_area_entered(_area):
	queue_free()

func detonate():
	create_hit_effect()
	queue_free()
	
func create_hit_effect():
	var effect = hitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_ReflectBox_area_entered(area):
	if reflectable:
		target = spawner
		look_at(spawner)
		convert_to_player_projectile()

#set hitbox to mask enemies instead of players
func convert_to_player_projectile():
	#disable player hurt box
	hitBox.set_collision_mask_bit(CollisionMasks.PlayerHurtBox, false)
	hitBox.set_collision_mask_bit(CollisionMasks.PlayerProjectile, true)
