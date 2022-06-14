extends Node2D
signal firstSpawn

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Decorations/Player.visible = true
	$Decorations/Player/Camera2D.current= true
	$Decorations/Player.canMove = true
	emit_signal("firstSpawn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
