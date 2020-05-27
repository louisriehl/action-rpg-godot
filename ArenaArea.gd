extends Area2D

export(NodePath) var cameraPath

onready var topLeft = $ArenaLimits/TopLeft
onready var botRight = $ArenaLimits/BotRight

var camera : Camera2D

func _ready():
	if cameraPath:
		camera = get_node(cameraPath)
	else:
		printerr("Camera path undefined for Arena")

func _on_ArenaArea_body_entered(body):
	print( "Player entered zone" )
	camera.set_limits(topLeft, botRight)


func _on_ArenaArea_body_exited(body):
	print( "Player left zone" )
	camera.reset_limits()
