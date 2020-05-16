extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var botRight = $Limits/BottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = botRight.position.y
	limit_right = botRight.position.x
