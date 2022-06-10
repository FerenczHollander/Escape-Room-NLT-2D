extends Node2D
var rng = RandomNumberGenerator.new()

onready var correctAnswer = $"Control/Button 1/Antwoord 1".text
onready var wrongAnswers = [$"Control/Button 2/Antwoord 2".text,$"Control/Button 3/Antwoord 3".text]
var wrongButtons = [1,2,3]
var onCooldown = false
var correctButton

func _ready():
	rng.randomize()
	correctButton = rng.randi_range(1,3)
	wrongButtons.remove(correctButton)
	for i in range(len(wrongButtons)-1):
		get_node("Control/Button "+str(wrongButtons[i])+"/Antwoord "+str(wrongButtons[i])).text = wrongAnswers[i]
	get_node("Control/Button "+str(correctButton)+"/Antwoord "+str(correctButton)).text = correctAnswer

func correct():
	get_node("Result/AnimationPlayer").play("Correct")

func incorrect():
	get_node("Result/AnimationPlayer").play("Incorrect")
	$"CanvasLayer/Time Left/Timer".start($"CanvasLayer/Time Left/Timer".time_left-Globals.timeOffWrongAnswer)
	onCooldown = true

func _on_Button_1_pressed():
	if onCooldown == false:
		if correctButton == 1:
			correct()
		else:
			incorrect()


func _on_Button_2_pressed():
	if onCooldown == false:
		if correctButton == 2:
			correct()
		else:
			incorrect()


func _on_Button_3_pressed():
	if onCooldown == false:
		if correctButton == 3:
			correct()
		else:
			incorrect()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Correct":
		Globals.questionsAnswered += 1
		$Player.nextScene()
	else:
		onCooldown = false
