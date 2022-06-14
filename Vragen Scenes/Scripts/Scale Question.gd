extends Node2D
var vergroting = 0.01
var vragen = ["res://Vragen Scenes/Vraag 3.tscn"]
var antwoorden = [3.1]
var currentSceneIndex
var offset = 0.1
var correctAnswer
var onCooldown = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	currentSceneIndex = vragen.find(get_tree().current_scene.filename)
	correctAnswer = antwoorden[currentSceneIndex]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if onCooldown == false:
		if Input.is_action_pressed("ui_up"):
			$Foto.scale.x += vergroting
			$Foto.scale.y += vergroting
		if Input.is_action_pressed("ui_down"):
			$Foto.scale.x -= vergroting
			$Foto.scale.y -= vergroting



func _on_Confirm_pressed():
	if $Foto.scale.x > (correctAnswer-offset) and $Foto.scale.x < (correctAnswer+offset):
		$Result/AnimationPlayer.play("Correct")
		$AudioPlayer.stream = load(Globals.correctSound)
		$AudioPlayer.play()
	else:
		$AudioPlayer.stream = load(Globals.incorrectSound)
		$AudioPlayer.play()
		$Result/AnimationPlayer.play("Incorrect")
		onCooldown = true
		Globals.wrongAnswers += 1
		if $"CanvasLayer/Time Left/Timer".time_left-(Globals.timeOffWrongAnswer*Globals.wrongAnswers) <= 0:
			$"CanvasLayer/Time Left/Timer".start(0.1)
		else:
			$"CanvasLayer/Time Left/Timer".start($"CanvasLayer/Time Left/Timer".time_left-(Globals.timeOffWrongAnswer*Globals.wrongAnswers))


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Incorrect":
		onCooldown = false
	if anim_name == "Correct":
		Globals.questionsAnswered += 1
		$Player.nextScene()
