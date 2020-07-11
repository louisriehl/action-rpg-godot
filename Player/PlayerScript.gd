extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION : = 500
export var FRICTION : = 500
export var MAX_SPEED : = 80
export var ROLL_SPEED_MODIFIER = 125

onready var stats = PlayerStats

enum {
	FORCE,
	MOVE,
	ROLL,
	ATTACK
}

var velocity : Vector2 = Vector2.ZERO
var enter_vector : Vector2 = Vector2.ZERO
var roll_vector : Vector2 = Vector2.DOWN
var state = MOVE

onready var swordHitbox = $SwordPivot/SwordHitbox
onready var animationPlayer = $AnimationPlayer
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationTree = $AnimationTree
onready var hurtBox = $HurtBox
onready var entryTimer = $EntryTimer
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	randomize()
	stats.connect("no_health", self, "handle_death")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	enter_vector = PlayerStats.previous_direction
	if enter_vector != Vector2.ZERO:	
		state = FORCE
		entryTimer.start()

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state()
		FORCE:
			force_state(delta)
			
func force_state(delta):
	velocity = enter_vector * MAX_SPEED
	update_animation_blend(enter_vector)
	animationState.travel("Run")
	move()

func move_state(delta): 

	var input_vector : Vector2 = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# returns vector clipped to radius of circle 1
	input_vector = input_vector.normalized()
		
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = roll_vector
		update_animation_blend(input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward( input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward( Vector2.ZERO, FRICTION * delta )

	move()

	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
	if Input.is_action_just_pressed("ui_roll"):
		state = ROLL

func move():
	# adjust velocity relative to frame delta: makes movement relative
	# to time instead of frame
	velocity = move_and_slide( velocity )

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED_MODIFIER
	move()
	animationState.travel("Roll")

func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	state = MOVE
	
func update_animation_blend(input_vector):
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtBox.start_invincibility(0.5)
	hurtBox.create_hit_effect(0, -8)
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
	
func handle_death():
	print("YOU DIED")
	SceneChanger.reload_scene()
	queue_free()
	
func trigger_force_walk(direction):
	enter_vector = direction
	state = FORCE
	entryTimer.start()

func _on_EntryTimer_timeout():
	state = MOVE
