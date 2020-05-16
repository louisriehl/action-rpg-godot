extends Node

# This class is an autoloaded singleton (see project settings)

export var max_health : int = 1 setget set_max_health
var health : int = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

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
