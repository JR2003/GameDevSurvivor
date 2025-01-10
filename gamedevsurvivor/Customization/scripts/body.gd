extends Node2D

@onready var body = $Sprite2D

var bodyKeys = []
var colorKeys = []
var currBody = 0
var currColor = 0

func _ready():
	setKeys()
	update()

func setKeys():
	bodyKeys = Global.bodies.keys()

func update():
	var currSprite = bodyKeys[currBody]
	body.texture = Global.bodies[currSprite]
	body.modulate =  Global.bodyColor[currColor]
	
	Global.selectBody = currSprite
	Global.selectBodyColor = Global.bodyColor[currColor]


func _on_collect_button_pressed() -> void:
	currBody = (currBody + 1) % bodyKeys.size()
	update()


func _on_color_button_2_pressed() -> void:
	currColor = (currColor + 1) % Global.bodyColor.size()
	update()
