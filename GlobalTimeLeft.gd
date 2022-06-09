extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var seconds = int($Timer.time_left)%60
	var minutes = int(($Timer.time_left/60))%60
	text = str(minutes)+":"+str(seconds)
	if minutes < 5:
		add_color_override("font_color",Color(1,0,0,1))
	else:
		add_color_override("font_color",Color(1,1,1,1))
	if seconds < 10:
		text = str(minutes)+":0"+str(seconds)
