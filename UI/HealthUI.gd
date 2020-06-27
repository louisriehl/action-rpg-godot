extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var keys = 0 setget set_keys

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty
onready var keyUI = $KeyUI

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	self.keys = PlayerStats.keys
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	PlayerStats.connect("keys_changed", self, "set_keys")

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15
	
func set_max_hearts(value): 
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15
		
func set_keys(value):
	keys = min(value, 3)
	if keyUI != null:
		keyUI.rect_size.x = keys * 10
