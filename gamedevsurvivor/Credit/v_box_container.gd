extends VBoxContainer

@export var scroll_speed: float = 50  
@onready var scroll_container = $".."  
@export var label_width: float = 500  
@export var label_height: float = 30  
@export var header_height: float = 50 
@export var header_font_size: int = 24  
@export var normal_font_size: int = 16  

func _ready():
	
	scroll_container.get_v_scroll_bar().modulate.a = 0
	var file = FileAccess.open("res://Credit/Credits.txt", FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		
		if line.begins_with("#"):
			add_header(line.substr(1).strip_edges()) 
		else:
			add_normal_text(line)
			
	file.close()
	
	# Initialisiere die Scrollposition
	scroll_container.get_v_scroll_bar().value = 0

func add_header(text: String):
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_FILL
	
	var font = SystemFont.new()
	label.add_theme_font_size_override("font_size", header_font_size)
	
	label.custom_minimum_size = Vector2(label_width, header_height)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	add_child(spacer)
	
	add_child(label)

func add_normal_text(text: String):
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_FILL
	
	label.add_theme_font_size_override("font_size", normal_font_size)
	
	label.custom_minimum_size = Vector2(label_width, label_height)
	
	add_child(label)

func _process(delta):
	var v_scroll_bar = scroll_container.get_v_scroll_bar()
	if v_scroll_bar.value < v_scroll_bar.max_value:
		v_scroll_bar.value += scroll_speed * delta
	else:
		v_scroll_bar.value = 0
