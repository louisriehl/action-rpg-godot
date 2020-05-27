extends Camera2D

onready var topLeft : Position2D = $Limits/TopLeft
onready var botRight : Position2D = $Limits/BottomRight

func _ready():
	reset_limits()

# returns limits to values configured by initial load
func reset_limits():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = botRight.position.y
	limit_right = botRight.position.x

func set_limits( limitTopLeft, limitTopRight):
	limit_top = limitTopLeft.position.y
	limit_left = limitTopLeft.position.x
	limit_bottom = limitTopRight.position.y
	limit_right = limitTopRight.position.x
