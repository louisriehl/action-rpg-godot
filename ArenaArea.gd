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
var bat_spawners = []
var dragon_spawners = []
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
	bat_spawners = get_node("ArenaSpawners/BatSpawners").get_children()
	dragon_spawners = get_node("ArenaSpawners/DragonSpawners").get_children()
	waveCooldownTimer.set_wait_time(wave_cooldown)
	
func _physics_process(delta):
	if state == WAVE_START:
		var wave = waves[current_wave]
		enemies_alive_in_wave = wave.size()
		var bat_count = 0
		var dragon_count = 0
		for i in range(wave.size()):
			if wave[i] == "BAT":
				spawn_enemy(wave[i], bat_spawners, bat_count)
				bat_count += 1
			if wave[i] == "DRAGON":
				spawn_enemy(wave[i], dragon_spawners, dragon_count)
				dragon_count += 1
		state = WAVE_UNDERWAY
	
func spawn_enemy(enemy, spawns, iterator):
	var spawn_point = spawns[iterator]
	create_at_spawn(EnemySpawnEffect.instance(), spawn_point)
	if enemy == "BAT":
		var bat = Bat.instance()
		bat.connect("died", self, "_spawned_enemy_died")
		bat.player_detection_modifier = 3
		create_at_spawn(bat, spawn_point)
	elif enemy == "DRAGON":
		var dragon = Dragon.instance()
		dragon.connect("died", self, "_spawned_enemy_died")
		dragon.player_detection_modifier = 3
		create_at_spawn(dragon, spawn_point)

func create_at_spawn(entity, spawn):
	var main = get_tree().current_scene
	entity.global_position = spawn.global_position	
	main.add_child(entity)
	
func end_arena():
	camera.reset_limits()
	queue_free()

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
		if current_wave == waves.size() - 1:
			end_arena()
		else:
			state = WAVE_COOLDOWN
			current_wave += 1
			waveCooldownTimer.start()
