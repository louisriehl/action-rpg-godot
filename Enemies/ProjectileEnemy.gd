extends KinematicBody2D

const Projectile = preload("res://Enemies/Projectile.tscn")
onready var projectileOrigin = $ProjectileOrigin
onready var playerDetection = $PlayerDetectionZone
onready var timer = $Timer

export var fire_delay_seconds : float = 1

var player
# face Right by default
var facingVector = transform.x
var playerPos

func _ready():
	timer.set_wait_time(fire_delay_seconds)

func _process(_delta):
	if playerDetection.can_see_player():
		player = playerDetection.player
		var direction_to_target = global_position.direction_to(player.global_position)
		# flip position of bullet spawner (and sprite, later) when target is other way
		if direction_to_target.dot(facingVector) < 0:
			facingVector *= Vector2(-1, 0)
			projectileOrigin.position *= Vector2(-1, 0)
	else:
		player = null

# for now, just fire a projectile every X seconds
func _on_Timer_timeout():
	if player:
		playerPos = player.global_position
		var projectile = Projectile.instance()
		projectile.target = playerPos
		var main = get_tree().current_scene
		projectile.global_position = projectileOrigin.global_position	
		main.add_child(projectile)
