extends Node2D

@onready var hair = $Sprite2D

var hairKeys = []
var colorKeys = []
var currHair = 0
var currColor = 0

func _ready():
	setKeys()
	update()

func setKeys():
	hairKeys = Global.hairs.keys()
	
func update():
	var currSprite = hairKeys[currHair]
	if currSprite == "none":
		hair.texture = null
	else: 
		hair.texture = Global.hairs[currSprite]
		hair.modulate =  Global.hairColor[currColor]
	
	Global.selectHair = currSprite
	Global.selectHairColor = Global.hairColor[currColor]


func _on_collect_button_pressed() -> void:
	currHair = (currHair + 1) % hairKeys.size()
	update()


func _on_color_button_2_pressed() -> void:
	currColor = (currColor + 1) % Global.hairColor.size()
	update()
