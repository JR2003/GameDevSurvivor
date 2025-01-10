extends Node2D

@onready var outfit = $Sprite2D

var outfitKeys = []
var colorKeys = []
var currOutfit = 0
var currColor = 0

func _ready():
	setKeys()
	update()

func setKeys():
	outfitKeys = Global.outfits.keys()

func update():
	var currSprite = outfitKeys[currOutfit]
	outfit.texture = Global.outfits[currSprite]
	outfit.modulate =  Global.defaultColor[currColor]
	
	Global.selectOutfit = currSprite
	Global.selectOutfitColor = Global.defaultColor[currColor]


func _on_collect_button_pressed() -> void:
	currOutfit = (currOutfit + 1) % outfitKeys.size()
	update()


func _on_color_button_2_pressed() -> void:
	currColor = (currColor + 1) % Global.defaultColor.size()
	update()
