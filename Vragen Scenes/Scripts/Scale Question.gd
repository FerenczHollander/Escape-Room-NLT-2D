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
	else:
		$Result/AnimationPlayer.play("Incorrect")
		onCooldown = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Incorrect":
		onCooldown = false
	if anim_name == "Correct":
		Globals.questionsAnswered += 1
		$Player.nextScene()