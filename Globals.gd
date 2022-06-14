extends Node
var timeStarted = 1800
var time_left = 1800
var questionsAnswered = 0
var maxQuestionsAnswered = 34
var lastPosition = Vector2(160,216)
var questionStart
var maxQuestions
var questionStep = -1
var timeOffWrongAnswer = 30.00
var wrongAnswers = 0
var timeLeftOpenVraag = 5
var firstSpawn = false
var currentInteractibleArea = null
var currentObjective = 0
var incorrectSound = "res://Assets/incorrect sound.mp3"
var correctSound = "res://Assets/correct sound.mp3"
var timeTaken = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass

func _reset_game():
	timeStarted = 2700
	time_left = 2700
	questionsAnswered = 0
	lastPosition = Vector2(160,216)
	questionStep = -1
	wrongAnswers = 0
	firstSpawn = false
	currentInteractibleArea = null
	currentObjective = 0
	timeTaken = 0
