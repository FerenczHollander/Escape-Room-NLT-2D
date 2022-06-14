extends KinematicBody2D
signal try_again
var velocity = 75
var direction = Vector2(0,0)
var animationAngle = 0
var animationDirection = 0
var canMove = true
var mustComplete = false
signal changeScene
var nextScene = null
var dialogueStep = 0
var sceneOrder = ["res://Overworld.tscn", 'res://Vragen Scenes/Vraag 1.1.tscn', 'res://Vragen Scenes/Vraag 1.2.tscn'
, 'res://Vragen Scenes/Vraag 1.3.tscn', 'res://Vragen Scenes/Vraag 1.4.tscn', 'res://Vragen Scenes/Vraag 2.1.tscn'
, 'res://Vragen Scenes/Vraag 2.2.tscn', 'res://Vragen Scenes/Vraag 3.1.tscn', 'res://Vragen Scenes/Vraag 3.2.tscn'
, 'res://Vragen Scenes/Vraag 4.1.tscn', 'res://Vragen Scenes/Vraag 4.2.tscn', 'res://Vragen Scenes/Vraag 4.3.tscn'
, 'res://Vragen Scenes/Vraag 4.4.tscn', 'res://Vragen Scenes/Vraag 4.5.tscn', 'res://Vragen Scenes/Vraag 5.1.tscn'
, 'res://Vragen Scenes/Vraag 5.2.tscn', 'res://Vragen Scenes/Vraag 5.3.tscn', 'res://Vragen Scenes/Vraag 5.4.tscn'
, 'res://Vragen Scenes/Vraag 5.5.tscn', 'res://Vragen Scenes/Vraag 6.1.tscn', 'res://Vragen Scenes/Vraag 6.2.tscn'
, 'res://Vragen Scenes/Vraag 6.3.tscn', 'res://Vragen Scenes/Vraag 6.4.tscn', 'res://Vragen Scenes/Vraag 7.1.tscn'
, 'res://Vragen Scenes/Vraag 7.2.tscn', 'res://Vragen Scenes/Vraag 7.3.tscn', 'res://Vragen Scenes/Vraag 7.4.tscn'
, 'res://Vragen Scenes/Vraag 8.1.tscn', 'res://Vragen Scenes/Vraag 8.2.tscn', 'res://Vragen Scenes/Vraag 8.3.tscn'
, 'res://Vragen Scenes/Vraag 8.4.tscn', 'res://Vragen Scenes/Vraag 8.5.tscn', 'res://Vragen Scenes/Vraag 9.1.tscn'
, 'res://Vragen Scenes/Vraag 9.2.tscn', 'res://Vragen Scenes/Vraag 9.3.tscn', 'res://Vragen Scenes/Eindvraag.tscn']

var dialogueStart
var maxDialogue
onready var objectives = ["Node2D/First House/Objective","Node2D/Pinkeln Gebied","Node2D/Na Pinkeln Gebied","Node2D/Steen","Node2D/Oceaan Vlonder",
"Node2D/Na Oceaan Vlonder","Node2D/Oceaan Strand","Node2D/Na Oceaan Strand","Node2D/Bloeiend Gras","Node2D/Klei","Node2D/Poehee","Node2D/Gras in Zonlicht","Node2D/Grasland",
"Node2D/Terugkeren","Node2D/Final Border","Node2D/Eindvraag"]
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
	if Globals.time_left < 1:
		get_tree().change_scene("res://Game Over Loss.tscn")
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
"Maar hij struikelde over een lego blokje,","Dus hij weet niet waar hij hem heeft gelaten","Kijken of ik wat kan terugvinden","Godverdedriedubbeltjes, de deur zit op slot",
 "Ik zie wel dat als ik deze vragen beantwoord de deur opengaat","Het boek is nog niet vol!","Je opa heeft pijn in zijn hart","Gefeliciteerd! Je kan eindelijk weg!",
"Je hebt de hele encyclopedie compleet", "Na het zoeken in een kast, ging ik door een deur","En ik ben nu ineens hier beland!",
"Ik moet maar de encyclopedie opnieuw maken","Aber jetzt muss ich pinkeln!","He! Een verlaten huis.","Dit lijkt mij een goede plek um zu pinkeln","Hier gaan we!","OH NEE!"
,"Mijn hele broek zit onder de plas!","Hoe kan dit? Er staat hier wat uitleg!","Poehoe, mijn hele broek zit onder de plas","Ik weet gelukkig wel nu hoe -","-het komt dat de muur mijn plas niet wou nemen"
,"Ik moet hem wel even schoonwassen","Waar kan ik dat doen?","Oh ja! Bij de zee!","Let's go!","Terwijl ik terugloop zie ik deze ENORME COOLE STENEN!","Wat kan dit zijn?","Misschien is het wel iets voor mijn encyclopedie?",
"Laat ik kijken!","Nou nou","Wat een mooie oceaan!","Dit lijkt mij een perfecte plek om mijn broek te wassen!","*Je wast je broek*", "Ik ben weer lekker schoon",
"Nu ik eraan denk,","Ik hoorde opa altijd praten over hoe mooi de oceanen waren.","Misschien zijn er wat fun facts!","Die kunnen dan in de encyclopedie!","Zie ik daar naar het zuiden nou wat?","JA!","Het is een walvis!",
"Daar moet ik echt gaan kijken!", "En dat is ook nog eens leerzaam","Kijk dan joh!","Wat een pracht beest","Wel raar dat hij zo dicht bij de kust is","Misschien moet ik dat opschrijven",
"Wat een belevenis!","Nu merk je wel echt dat je uit de magische kast komt!","Ik zag bij dat oude huis ook nog wat grassen","Ik denk dat ik daar ga kijken!","Dan begint mijn encyclopedie af te komen!",
"Wat staat dit mooi in de bloei!","Waarschijnlijk kan ik hier wat leren-","-over grassoorten!","Ik denk helaas dat ik hierna door moet","Ik wil namelijk wel wat meer-","-over grassen weten!"
,"Gadverderrie!","Welke curieuze smurrie is dit?","Dit lijkt wel iets van modder","OH NEE!","Het is klei!","Ik pak maar weer mijn pen!","En daarna snel door op mijn tocht",
"Wat een grasvlakte!","Hier kan ik zeker wat leuke dingetjes vinden!","Ik ga maar opzoek","De zon staat hier lekker op!","Komt vast door de weinige beschutting","Wat had licht ook alweer met planten?","OH JA!","Fotosynthese",
"Dan ga ik dat maar eens bestuderen!","Nog wat mooie grasjes","Wat lijken ze oud","Ik zie ook aanwijzingen van grazers","Dat is interessant", "Laat ik dat maar onderzoeken!",
"Het boek is vol!","Wat zal mijn opa daar blij mee zijn.","En wat heb ik leuke herinneringen hieraan!","Nog 1 laatste vraag!"]
#Change scenes
func nextScene():
	if get_tree().current_scene.filename == "res://Overworld.tscn":
		Globals.lastPosition = global_position
	if Globals.questionStart+Globals.questionStep == (Globals.questionStart+Globals.maxQuestions):
		get_tree().change_scene(sceneOrder[0])
	elif get_tree().current_scene.filename == "res://Vragen Scenes/Eindvraag.tscn":
		Globals.timeTaken = Globals.timeStarted-Globals.time_left
		get_tree().change_scene("res://Game Over Win.tscn")
	else:
		get_tree().change_scene(sceneOrder[Globals.questionStart+Globals.questionStep])

#Areas
func _exit_area():
	dialogueStep = 0
	root.get_node(Globals.currentInteractibleArea).queue_free()
	Globals.currentObjective += 1
	Globals.currentInteractibleArea = null
	if Globals.currentObjective < len(objectives):
		root.get_node(objectives[Globals.currentObjective]).monitorable = true
		root.get_node(objectives[Globals.currentObjective]).monitoring = true

func _on_FirstHouse_Door_body_entered(body):
	Globals.currentInteractibleArea = "First House"
	dialogueStart = 5
	maxDialogue = 2
	Globals.questionStart = 1
	Globals.maxQuestions = 4
	$UI/Dialogue.visible = true
func _on_FirstHouse_Door_body_exited(body):
	Globals.currentInteractibleArea = null
	dialogueStep = 0

func _on_Final_Border_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Final Border"
	if Globals.maxQuestionsAnswered > Globals.questionsAnswered:
		dialogueStart = 7
		maxDialogue = 2
		$UI/Dialogue.visible = true
	if Globals.maxQuestionsAnswered == Globals.questionsAnswered:
		dialogueStart = 9
		maxDialogue = 2
		root.get_node("Node2D/Final Border/Barrier").queue_free()
		$"UI/Arrow Objective".scale = Vector2(0,0)



func _on_Final_Border_body_exited(body):
	if Globals.maxQuestionsAnswered == Globals.questionsAnswered:
		_exit_area()
	else:
		Globals.currentInteractibleArea = null
		dialogueStep = 0

func _on_Pinkeln_Gebied_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Pinkeln Gebied"
	dialogueStart = 15
	maxDialogue = 6
	mustComplete = true
	Globals.questionStart = 5
	Globals.maxQuestions = 2
	$UI/Dialogue.visible = true



func _on_Na_Pinkeln_Gebied_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Na Pinkeln Gebied"
	dialogueStart = 21
	maxDialogue = 7


func _on_Na_Pinkeln_Gebied_body_exited(body):
	_exit_area()
	pass # Replace with function body.


func _on_Steen_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Steen"
	dialogueStart = 28
	maxDialogue = 4
	mustComplete = true
	Globals.questionStart = 9
	Globals.maxQuestions = 5
	$UI/Dialogue.visible = true


func _on_Oceaan_Vlonder_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Oceaan Vlonder"
	Globals.questionStart = 14
	Globals.maxQuestions = 4
	dialogueStart = 32
	maxDialogue = 9
	mustComplete = true
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Bloeiend_Gras_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Bloeiend Gras"
	Globals.questionStart = 7
	Globals.maxQuestions = 2
	dialogueStart = 55
	maxDialogue = 6
	mustComplete = true
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Na_Oceaan_Vlonder_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Na Oceaan Vlonder"
	dialogueStart = 41
	maxDialogue = 5
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Na_Oceaan_Vlonder_body_exited(body):
	_exit_area()


func _on_Oceaan_Strand_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Oceaan Strand"
	Globals.questionStart = 18
	Globals.maxQuestions = 5
	dialogueStart = 46
	maxDialogue = 4
	mustComplete = true
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Na_Oceaan_Strand_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Na Oceaan Strand"
	dialogueStart = 50
	maxDialogue = 5
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Na_Oceaan_Strand_body_exited(body):
	_exit_area()


func _on_Klei_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Klei"
	Globals.questionStart = 23
	Globals.maxQuestions = 4
	dialogueStart = 61
	maxDialogue = 7
	mustComplete = true
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Poehee_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Poehee"
	dialogueStart = 68
	maxDialogue = 3
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Poehee_body_exited(body):
	_exit_area()


func _on_Gras_in_Zonlicht_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Gras in Zonlicht"
	Globals.questionStart = 27
	Globals.maxQuestions = 5
	dialogueStart = 71
	maxDialogue = 6
	mustComplete = true
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Grasland_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Grasland"
	Globals.questionStart = 32
	Globals.maxQuestions = 3
	dialogueStart = 77
	maxDialogue = 5
	mustComplete = true
	$UI/Dialogue.visible = true


func _on_Terugkeren_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Terugkeren"
	dialogueStart = 82
	maxDialogue = 3
	$UI/Dialogue.visible = true
	pass # Replace with function body.


func _on_Terugkeren_body_exited(body):
	_exit_area()


func _on_Eindvraag_body_entered(body):
	Globals.currentInteractibleArea = "Node2D/Eindvraag"
	Globals.questionStart = 35
	Globals.maxQuestions = 2
	dialogueStart = 85
	maxDialogue = 1
	$UI/Dialogue.visible = true
	mustComplete = true
	
	pass # Replace with function body.
