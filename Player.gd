extends KinematicBody2D
var velocity = 75
var direction = Vector2(0,0)
var animationAngle = 0
var animationDirection = 0
var canMove = true
var mustComplete = false
signal changeScene
var nextScene = null
var dialogueStep = 0
var sceneOrder = ["res://Overworld.tscn","res://Vragen Scenes/Dier spoor.tscn","res://Vragen Scenes/Dageraad grootte.tscn",
"res://Vragen Scenes/3 fases silica.tscn","res://Vragen Scenes/Plas tegen muur.tscn","res://Vragen Scenes/3 vaste vormen silica.tscn",
"res://Vragen Scenes/silica concentratie sorteren.tscn","res://Vragen Scenes/water bijzondere stromatoliet.tscn"]
var dialogueStart
var maxDialogue
onready var objectives = ["Node2D/First House/Objective","Node2D/Pinkeln Gebied","Node2D/Na Pinkeln Gebied","Node2D/Steen"]
onready var objectivePosition
onready var root = get_tree().get_root()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.questionStep += 1
	if get_tree().current_scene.filename == "res://Beginning World.tscn":
		Globals.currentInteractibleArea = "First_Spawn"
		dialogueStart = 0
		maxDialogue = 5
		$UI/Dialogue.visible = true
	if get_tree().current_scene.filename == "res://Overworld.tscn":
		mustComplete = false
		Globals.questionStep = 0
		Globals.currentObjective += 1
		if Globals.currentObjective < len(objectives):
			root.get_node(objectives[Globals.currentObjective]).monitorable = true
			root.get_node(objectives[Globals.currentObjective]).monitoring = true
		global_position = Globals.lastPosition
		if Globals.firstSpawn == false:
			Globals.firstSpawn = true
			Globals.currentInteractibleArea = "First_Spawn"
			dialogueStart = 11
			maxDialogue = 4
			$UI/Dialogue.visible = true
		else:
			root.get_node(Globals.currentInteractibleArea).queue_free()
			Globals.currentInteractibleArea = null
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Camera and canMove
	if visible == false:
		$Camera2D.current = false
		canMove = false
	else:
		$Camera2D.current = true
		canMove = true
	if Globals.currentInteractibleArea != null and visible == true:
		if dialogueStep < maxDialogue-1:
			canMove = false
		elif mustComplete == true:
			canMove = false
		else:
			canMove = true
	#MOVEMENT
	direction = Vector2(0,0)
	if canMove == true:
		if Input.is_action_pressed("ui_up"):
			direction.y = -1
		elif Input.is_action_pressed("ui_down"):
			direction.y = 1
		elif Input.is_action_pressed("ui_left"):
			direction.x = -1
		elif Input.is_action_pressed("ui_right"):
			direction.x = 1
	#Animations
	if direction != Vector2(0,0):
		if rad2deg(direction.angle()) < 0:
			animationAngle = 360+rad2deg(direction.angle())
		else:
			animationAngle = rad2deg(direction.angle())
		animationDirection = ((int((animationAngle+1)/90))+1)
		if animationDirection == -1:
			animationDirection = 7
		$AnimatedSprite.animation = "Walk_"+str(animationDirection%8)
	else:
		$AnimatedSprite.frame = 1
	move_and_slide(direction.normalized()*velocity)
	
#INTERACTIONS
	#Text animation
	if Globals.currentInteractibleArea == null:
		$"UI/Arrow Objective".visible = true
		if $UI/Interact.visible_characters > 0:
			$UI/Interact.visible_characters -= 1
		else:
			$UI/Interact.visible_characters = 0
		$UI/Dialogue.visible = false
		$UI/Dialogue.visible_characters = 0
	elif visible == true:
		$"UI/Arrow Objective".visible = false 
		$UI/Dialogue.visible = true
		$UI/Dialogue.text = dialogue[(dialogueStart+dialogueStep)]
		if len($UI/Interact.text) > $UI/Interact.visible_characters:
			$UI/Interact.visible_characters += 1
		if len($UI/Dialogue.text) > $UI/Dialogue.visible_characters:
			$UI/Dialogue.visible_characters += 1
		if Input.is_action_just_pressed("LMB"):
			if dialogueStep < maxDialogue-1:
				dialogueStep += 1
				$UI/Dialogue.visible_characters = 0
	#Different interactions
	if visible == true and Input.is_action_just_pressed("ui_interact") and dialogueStep == maxDialogue-1 and Globals.currentInteractibleArea != null:
		nextScene()
#Interactible objects
	#Leaving spawn
	if direction != Vector2.ZERO:
		if Globals.currentInteractibleArea == "First_Spawn":
			Globals.currentInteractibleArea = null
			dialogueStep = 0
	#Objective
	if get_tree().current_scene.filename == "res://Overworld.tscn" or get_tree().current_scene.filename == "res://Beginning World.tscn":
		if Globals.currentObjective < len(objectives):
			objectivePosition = root.get_node(objectives[Globals.currentObjective]).global_position
			$"UI/Arrow Objective".rotation_degrees = rad2deg((objectivePosition-global_position).angle())+90

#Dialogue
var dialogue = ["Eindelijk ben ik bij opa's huis","Hij heeft mij verteld dat zijn encyclopedie hier ligt",
"Maar hij struikelde over een lego blokje,","Dus hij heeft hem per ongeluk in de haard gegooid","Kijken of ik wat kan terugvinden","Godverdedriedubbeltjes, de deur zit op slot",
 "Ik zie wel dat als ik deze vragen beantwoord de deur opengaat","De graslanden en grazers schreeuwen nog om jouw hulp!","HELP ZE!","Gefeliciteerd! Je kan eindelijk weg!",
"Het hele eiland is je dankbaar!", "Na het zoeken ben ik in de haard gevallen!","En ik ben nu ineens hier beland!",
"Ik krijg een gevoel dat ik de natuur moet helpen","Aber jetzt muss ich pinkeln!","Dit lijkt mij een goede plek um zu pinkeln","Hier gaan we!","OH NEE!","Mijn hele broek zit onder de plas!",
"Hoe kan dit? Er staat hier wat uitleg!","Poehoe, mijn hele broek zit onder de plas","Ik weet gelukkig wel nu hoe -","-het komt dat de muur mijn plas niet wou nemen","Ik moet hem wel even schoonwassen"
,"Waar kan ik dat doen?","Oh ja! Bij de zee!","Let's go!","Terwijl ik terugloop zie ik deze ENORME COOLE STENEN!","Wat kan dit zijn?","Misschien is het wel iets voor mijn encyclopedie?",
"Laat ik kijken!"]
#Change scenes
func nextScene():
	if get_tree().current_scene.filename == "res://Overworld.tscn":
		Globals.lastPosition = global_position
	if Globals.questionStart+Globals.questionStep == (Globals.questionStart+Globals.maxQuestions):
		get_tree().change_scene(sceneOrder[0])
	else:
		get_tree().change_scene(sceneOrder[Globals.questionStart+Globals.questionStep])

#Areas
func _on_FirstHouse_Door_body_entered(body):
	Globals.currentInteractibleArea = "First House"
	dialogueStart = 5
	maxDialogue = 2
	Globals.questionStart = 1
	Globals.maxQuestions = 3
	$UI/Dialogue.visible = true
func _on_FirstHouse_Door_body_exited(body):
	Globals.currentInteractibleArea = null
	dialogueStep = 0

func _on_Final_Border_body_entered(body):
	Globals.currentInteractibleArea = "Final Border"
	if Globals.maxQuestionsAnswered > Globals.questionsAnswered:
		dialogueStart = 7
		maxDialogue = 2
		$UI/Dialogue.visible = true
	if Globals.maxQuestionsAnswered == Globals.questionsAnswered:
		dialogueStart = 9
		maxDialogue = 2



func _on_Final_Border_body_exited(body):
	Globals.currentInteractibleArea = null
	dialogueStep = 0


func _on_Pinkeln_Gebied_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Pinkeln Gebied"
	dialogueStart = 15
	maxDialogue = 5
	mustComplete = true
	Globals.questionStart = 4
	Globals.maxQuestions = 2
	$UI/Dialogue.visible = true



func _on_Na_Pinkeln_Gebied_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Na Pinkeln Gebied"
	dialogueStart = 20
	maxDialogue = 7


func _on_Na_Pinkeln_Gebied_body_exited(body):
	dialogueStep = 0
	root.get_node(Globals.currentInteractibleArea).queue_free()
	Globals.currentObjective += 1
	Globals.currentInteractibleArea = null
	if Globals.currentObjective < len(objectives):
		root.get_node(objectives[Globals.currentObjective]).monitorable = true
		root.get_node(objectives[Globals.currentObjective]).monitoring = true
	pass # Replace with function body.


func _on_Steen_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Steen"
	dialogueStart = 27
	maxDialogue = 4
	mustComplete = true
	Globals.questionStart = 6
	Globals.maxQuestions = 2
	$UI/Dialogue.visible = true
