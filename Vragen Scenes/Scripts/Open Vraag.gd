extends Node2D
var onCooldown = false
onready var beginningText = $"Control/Gebruiker Antwoord".text

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Confirm_pressed():
	if onCooldown == false:
		$"Control/Gebruiker Antwoord".rect_size.y = $"Control/Gebruiker Antwoord".rect_size.y * 0.5
		$"Control/Confirm".visible = false
		$"Control/Juist".visible = true
		$"Control/Onjuist".visible = true
		$"Control/Correcte Antwoord".visible = true

func _on_Juist_pressed():
	if onCooldown == false:
		$Result/AnimationPlayer.play("Correct")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Correct":
		Globals.questionsAnswered += 1
		$Player.nextScene()
	if anim_name == "Incorrect":
		onCooldown = false
		$"Control/Gebruiker Antwoord".rect_size.y = $"Control/Gebruiker Antwoord".rect_size.y * 2
		$"Control/Confirm".visible = true
		$"Control/Juist".visible = false
		$"Control/Onjuist".visible = false
		$"Control/Correcte Antwoord".visible = false
		$"Control/Gebruiker Antwoord".text = beginningText
	

func _on_Onjuist_pressed():
	if onCooldown == false:
		$"CanvasLayer/Time Left/Timer".start($"CanvasLayer/Time Left/Timer".time_left-Globals.timeOffWrongAnswer)
		$Result/AnimationPlayer.play("Incorrect")
		onCooldown = true
	pass # Replace with function body.
