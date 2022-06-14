extends Node2D

onready var answers =  [$"Control/Button 1/Antwoord".text,$"Control/Button 2/Antwoord".text,$"Control/Button 3/Antwoord".text]
var buttons = [1,2,3]
var onCooldown = false
var correctButton
var correctAnswer

func _ready():
	correctAnswer = answers[0]
	randomize()
	answers.shuffle()
	for i in range(1,(buttons.size()+1)):
		get_node("Control/Button "+str(i)+"/Antwoord").text = answers[i-1]
	for i in range(1,(buttons.size())+1):
		if get_node("Control/Button "+str(i)+"/Antwoord").text == correctAnswer:
			correctButton = buttons[i-1]
	print(correctButton)
	

func correct():
	get_node("Result/AnimationPlayer").play("Correct")
	$AudioPlayer.stream = load(Globals.correctSound)
	$AudioPlayer.play()

func incorrect():
	get_node("Result/AnimationPlayer").play("Incorrect")
	$AudioPlayer.stream = load(Globals.incorrectSound)
	$AudioPlayer.play()
	Globals.wrongAnswers += 1
	if $"CanvasLayer/Time Left/Timer".time_left-(Globals.timeOffWrongAnswer*Globals.wrongAnswers) <= 0:
		$"CanvasLayer/Time Left/Timer".start(0.1)
	else:
		$"CanvasLayer/Time Left/Timer".start($"CanvasLayer/Time Left/Timer".time_left-(Globals.timeOffWrongAnswer*Globals.wrongAnswers))
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
