extends Node2D

@onready var accessory = $Sprite2D

var accessoryKeys = []
var colorKeys = []
var currAccessory = 0
var currColor = 0

func _ready():
	setKeys()
	update()

func setKeys():
	accessoryKeys = Global.accessories.keys()
	
func update():
	var currSprite = accessoryKeys[currAccessory]
	if currSprite == "none":
		accessory.texture = null
	else: 
		accessory.texture = Global.accessories[currSprite]
		accessory.modulate =  Global.defaultColor[currColor]
	
	Global.selectAccessory = currSprite
	Global.selectAccessoryColor = Global.defaultColor[currColor]


func _on_collect_button_pressed() -> void:
	currAccessory = (currAccessory + 1) % accessoryKeys.size()
	update()

func _on_color_button_2_pressed() -> void:
	currColor = (currColor + 1) % Global.defaultColor.size()
	update()
