extends Node

# This class is an autoloaded singleton (see project settings)
const max_keys = 3

export var max_health : int = 1 setget set_max_health
var health : int = max_health setget set_health
var keys : int = 0 setget set_keys

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal keys_changed(value)

func _ready():
	self.health = max_health

func set_health( value ):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health )
	emit_signal("max_health_changed", max_health)
	
func set_keys(value):
	keys = min(value, max_keys)
	emit_signal("keys_changed", keys)
	
func restore_all_health():
	self.health = max_health
