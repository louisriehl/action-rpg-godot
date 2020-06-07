extends Area2D

export(NodePath) var cameraPath
# next time we should use PoolStringArray, more optimized and strongly typed
export var waves = [[]]
export var wave_cooldown : float = 1

# types of enemies to spawn
var Bat = preload("res://Enemies/Bat.tscn")
var Dragon = preload("res://Enemies/ProjectileEnemy.tscn")
var EnemySpawnEffect = preload("res://Effects/EnemyDeathEffect.tscn")

# boundaries for camera to snap to when arena is activated
onready var topLeft = $ArenaLimits/TopLeft
onready var botRight = $ArenaLimits/BotRight

# on player entry, triggers arena start
onready var triggerArea = $TriggerArea

# timers
onready var waveCooldownTimer = $WaveCooldown 

var blockers = []
var spawners = []
var state = INACTIVE
var current_wave = 0
var enemies_alive_in_wave = 0

enum {
	INACTIVE,
	WAVE_START,
	WAVE_UNDERWAY,
	WAVE_COOLDOWN
}

var camera : Camera2D

func _ready():
	if cameraPath:
		camera = get_node(cameraPath)
	else:
		printerr("Camera path undefined for Arena")
	if !waves:
		printerr("No waves defined for arena")
	
	blockers = get_node("ArenaBlockers").get_children()
	spawners = get_node("ArenaSpawners").get_children()
	waveCooldownTimer.set_wait_time(wave_cooldown)
	
func _physics_process(delta):
	if state == WAVE_START:
		var wave = waves[current_wave]
		enemies_alive_in_wave = wave.size()
		for i in range(wave.size()):
			spawn_enemy(wave[i], i)
	state = WAVE_UNDERWAY
	
func spawn_enemy(enemy, iterator):
	var spawn_point = spawners[iterator]
	create_at_spawn(EnemySpawnEffect.instance(), spawn_point)
	if enemy == "BAT":
		var bat = Bat.instance()
		bat.connect("died", self, "_spawned_enemy_died")
		create_at_spawn(bat, spawn_point)
	
func create_at_spawn(entity, spawn):
	var main = get_tree().current_scene
	entity.global_position = spawn.global_position	
	main.add_child(entity)

func _on_ArenaArea_body_entered(body):
	camera.set_limits(topLeft, botRight)
	for block in blockers:
		block.get_child(0).set_deferred("disabled", false)
	waveCooldownTimer.start()

func _on_WaveCooldown_timeout():
	print("WAVE START")
	state = WAVE_START
	
func _spawned_enemy_died():
	enemies_alive_in_wave -= 1
	if enemies_alive_in_wave <= 0:
		state = WAVE_COOLDOWN
		current_wave += 1
		waveCooldownTimer.start()
