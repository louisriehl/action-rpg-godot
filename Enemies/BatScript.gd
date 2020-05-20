extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

export var acceleration = 300
export var max_speed = 50
export var friction = 200
export var push_force = 400
export var wander_target_range = 4

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
export var state = IDLE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedBat
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

func _ready():
	state = pick_random_state([WANDER, IDLE])
	sprite.play()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				wander_or_idle()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				wander_or_idle()
			
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= wander_target_range:
				wander_or_idle()
			
		CHASE: 
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * push_force
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func wander_or_idle():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_HurtBox_invincibility_started():
	animationPlayer.play("Start")
  
func _on_HurtBox_invincibility_ended():
	animationPlayer.play("Stop")
