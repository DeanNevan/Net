extends TextureButton

signal selected(button)

var name_CN = ""
var introduction = ""
var NodeScene
var color

var on_mouse = false

func _init():
	add_to_group("build_buttons")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("pressed", self, "_on_pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_button_down():
	rect_scale = Vector2(0.9, 0.9)
	
	pass

func _on_button_up():
	rect_scale = Vector2(1, 1)
	pass

func _on_mouse_entered():
	on_mouse = true
	pass

func _on_mouse_exited():
	on_mouse = false
	pass

func _pressed():
	emit_signal("selected", self)
