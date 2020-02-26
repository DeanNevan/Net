extends TextureButton

signal selected(list_number)

var list_number = 1

var is_pressed = false
var on_mouse = false

var Tween1 = Tween.new()

var state

func _init():
	add_to_group("list_choices")

func _ready():
	for i in get_tree().get_nodes_in_group("list_choice"):
		if i != self:
			i.connect("pressed", self, "_on_other_pressed")
	
	add_child(Tween1)
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	Tween1.start()
	#rect_position += Vector2(50, 0)
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("pressed", self, "_on_pressed")
	$Light2D.color = modulate
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Tween1.is_active():
		match state:
			0:
				rect_min_size = Vector2(75, 138)
				$Light2D.energy = 0
			1:
				rect_min_size = Vector2(75, 138)
				$Light2D.energy = 1
			2:
				rect_min_size = Vector2(75, 240)
				$Light2D.energy = 1
	$Light2D.position = rect_position

func _on_mouse_entered():
	state = 1
	show()
	pass

func _on_mouse_exited():
	state = 0
	shrink()
	pass

func _on_pressed():
	emit_signal("selected", list_number)
	is_pressed = true
	#Tween1.stop_all()
	state = 2
	fix()
	pass

func _on_other_pressed():
	is_pressed = false
	state = 0
	shrink()

func show():
	#if Tween1.is_active():
		#yield(Tween1, "tween_completed")
	Tween1.stop_all()
	Tween1.interpolate_property(self, "rect_min_size", rect_min_size, Vector2(75, 138), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	#yield(Tween1, "tween_completed")
	#rect_position = Vector2(0, rect_position.y)
	#rect_min_size = Vector2(75, 138)
	#$Light2D.energy = 1

func shrink():
	#if Tween1.is_active():
		#yield(Tween1, "tween_completed")
	Tween1.stop_all()
	Tween1.interpolate_property(self, "rect_min_size", rect_min_size, Vector2(75, 138), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	#yield(Tween1, "tween_completed")
	#rect_position = Vector2(50, rect_position.y)
	#rect_min_size = Vector2(75, 138)
	#$Light2D.energy = 0

func fix():
	#if Tween1.is_active():
		#yield(Tween1, "tween_completed")
	Tween1.stop_all()
	Tween1.interpolate_property(self, "rect_min_size", rect_min_size, Vector2(75, 210), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	#yield(Tween1, "tween_completed")
	#rect_position = Vector2(0, rect_position.y)
	#rect_min_size = Vector2(75, 200)
	#$Light2D.energy = 1
