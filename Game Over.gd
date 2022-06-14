extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene.filename == "res://Game Over Win.tscn":
		var seconds = int(Globals.timeTaken)%60
		var minutes = int((Globals.timeTaken/60))%60
		$Statistiek.text = "Je hebt er "+str(minutes)+" minuten en "+str(seconds)+" seconden over gedaan"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Try_Again_pressed():
	Globals._reset_game()
	get_tree().change_scene("res://Beginning World.tscn")
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
