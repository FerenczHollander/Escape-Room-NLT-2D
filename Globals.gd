extends Node
var time_left = 2700
var questionsAnswered = 3
var maxQuestionsAnswered = 40
var lastPosition = Vector2(160,216)
var questionStart
var maxQuestions
var questionStep = -1
var timeOffWrongAnswer = 30.00
var firstSpawn = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
