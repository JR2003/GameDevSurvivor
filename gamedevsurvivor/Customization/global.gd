extends Node

var bodies = {
	"01" : preload("res://assets/Character/body/body.png")
}

var hairs = {
	"none" : null,
	"01" : preload("res://assets/Character/hair/hair1.png"),
	"02" : preload("res://assets/Character/hair/hair2.png"),
}

var outfits = {
	"01" : preload("res://assets/Character/outfit/boxer.png"),
	"02" : preload("res://assets/Character/outfit/outfit1.png"),
	"03" : preload("res://assets/Character/outfit/outfit2.png"),
	"04" : preload("res://assets/Character/outfit/panties.png"),
}

var accessories = {
	"none" : null,
	"01" : preload("res://assets/Character/accessories/hat1.png"),
	"02" : preload("res://assets/Character/accessories/hat2.png"),
}

var bodyColor = [
	Color(1, 1, 1),
	Color(1.0, 0.87, 0.77),
	Color(1.0, 0.80, 0.67),
	Color(0.96, 0.82, 0.72),
	Color(0.65, 0.45, 0.30),
	Color(0.55, 0.35, 0.20),  
	Color(0.45, 0.28, 0.15),
	Color(0.65, 0.45, 0.30),
	Color(0.6, 1, 0.6),
	Color(1, 1, 0.6),
	Color(0.8, 0.6, 1),
	Color(1, 0.8, 0.6),
]

var hairColor = [
	Color(1, 1, 1),
	Color(1.0, 0.9, 0.6),
	Color(1.0, 0.85, 0.4),
	Color(0.8, 0.6, 0.4),
	Color(0.1, 0.1, 0.2),
	Color(0.7, 0.3, 0.2),
	Color(0.8, 0.7, 1.0),
	Color(0.7, 0.8, 1.0),
	Color(0.2, 0.8, 0.4),
	Color(1.0, 0.3, 0.3),
	Color(0.6, 1, 0.6),
	Color(1, 1, 0.6),
	Color(0.8, 0.6, 1),
	Color(1, 0.8, 0.6),
]

var defaultColor = [
	Color(1, 1, 1),
	Color(1, 0, 0),         # Rot
	Color(0, 1, 0),        # Grün
	Color(0, 0, 1),         # Blau
	Color(1, 1, 0),       # Gelb
	Color(1, 0, 1),      # Magenta
	Color(0, 1, 1),         # Cyan
	Color(1, 1, 1),        # Weiß
	Color(0, 0, 0),        # Schwarz
]

var selectBody = "01"
var selectHair = "none"
var selectOutfit = "01"
var selectAccessory = "none"
var selectBodyColor = bodyColor[0] 
var selectHairColor = hairColor[0] 
var selectOutfitColor = defaultColor[0] 
var selectAccessoryColor = defaultColor[0] 
