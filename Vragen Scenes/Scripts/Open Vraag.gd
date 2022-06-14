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
		$"Control/Gebruiker Antwoord".readonly = true
		$"Control/Gebruiker Antwoord".rect_size.y = $"Control/Gebruiker Antwoord".rect_size.y * 0.5
		$"Control/Confirm".visible = false
		$"Control/Juist".visible = true
		$"Control/Onjuist".visible = true
		$"Control/Correcte Antwoord".visible = true

func _on_Juist_pressed():
	if onCooldown == false:
		if beginningText == $"Control/Gebruiker Antwoord".text:
			if $"CanvasLayer/Time Left/Timer".time_left > Globals.timeLeftOpenVraag:
				$"CanvasLayer/Time Left/Timer".start(Globals.timeLeftOpenVraag)
			$Result/AnimationPlayer.play("Incorrect")
			$AudioPlayer.stream = load(Globals.incorrectSound)
			$AudioPlayer.play()
			onCooldown = true
		else:	
			$Result/AnimationPlayer.play("Correct")
			$AudioPlayer.stream = load(Globals.correctSound)
			$AudioPlayer.play()



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Correct":
		Globals.questionsAnswered += 1
		$Player.nextScene()
	if anim_name == "Incorrect":
		onCooldown = false
		$"Control/Gebruiker Antwoord".readonly = false
		$"Control/Gebruiker Antwoord".rect_size.y = $"Control/Gebruiker Antwoord".rect_size.y * 2
		$"Control/Confirm".visible = true
		$"Control/Juist".visible = false
		$"Control/Onjuist".visible = false
		$"Control/Correcte Antwoord".visible = false
		$"Control/Gebruiker Antwoord".text = beginningText
	

func _on_Onjuist_pressed():
	if onCooldown == false:
		Globals.wrongAnswers += 1
		if $"CanvasLayer/Time Left/Timer".time_left-(Globals.timeOffWrongAnswer*Globals.wrongAnswers) <= 0:
			$"CanvasLayer/Time Left/Timer".start(0.1)
		else:
			$"CanvasLayer/Time Left/Timer".start($"CanvasLayer/Time Left/Timer".time_left-(Globals.timeOffWrongAnswer*Globals.wrongAnswers))
		$Result/AnimationPlayer.play("Incorrect")
		$AudioPlayer.stream = load(Globals.incorrectSound)
		$AudioPlayer.play()
		onCooldown = true
	pass # Replace with function body.
