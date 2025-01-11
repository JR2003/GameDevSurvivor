extends Control

@onready var buttonas = $PanelContainer/VBoxContainer/attackspeed
@onready var maxcdlabel = $PanelContainer/MaxCd
var player = null
var weapon = null

func _ready() -> void:
	player = get_parent().get_node("Player")
	weapon = get_parent().get_node("Weapon2")
	maxcdlabel.visible = false
	
func close_upgrade_menu():
	get_tree().paused = false
	queue_free()

func _process(delta: float) -> void:
	if weapon.shoot_cd== 0.5:
		maxcdlabel.visible = true
		buttonas.disabled = true

func _on_damage_pressed() -> void:
	print("ich will damage")
	weapon.upgrade_damage()
	close_upgrade_menu()


func _on_attackspeed_pressed() -> void:
	print("ich will attackspeed")
	weapon.upgrade_attack_speed()
	close_upgrade_menu()


func _on_pierce_pressed() -> void:
	print("ich will pierce")
	weapon.upgrade_pierce()
	close_upgrade_menu()
