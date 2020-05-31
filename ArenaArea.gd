extends Area2D

export(NodePath) var cameraPath

# boundaries for camera to snap to when arena is activated
onready var topLeft = $ArenaLimits/TopLeft
onready var botRight = $ArenaLimits/BotRight

# trigger area to start arena
onready var triggerArea = $TriggerArea

var blockers = []

var camera : Camera2D

func _ready():
	if cameraPath:
		camera = get_node(cameraPath)
	else:
		printerr("Camera path undefined for Arena")
	
	blockers = get_node("ArenaBlockers").get_children()

func _on_ArenaArea_body_entered(body):
	print( "Player entered zone" )
	camera.set_limits(topLeft, botRight)
	for block in blockers:
		block.get_child(0).set_deferred("disabled", false)
