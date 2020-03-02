extends TextureButton

signal left_mouse_button
signal right_mouse_button
signal middle_mouse_button
signal wheel_up
signal wheel_down


var on_mouse = false

func _input(event):
	if on_mouse:
		if event.is_action_pressed("left_mouse_button"):
			emit_signal("left_mouse_button")
		if event.is_action_pressed("right_mouse_button"):
			emit_signal("right_mouse_button")
		if event.is_action_pressed("middle_mouse_button"):
			emit_signal("middle_mouse_button")
		if event.is_action_released("wheel_up"):
			emit_signal("wheel_up")
		if event.is_action_released("wheel_down"):
			emit_signal("wheel_down")

func _init():
	add_to_group("passUI")

func _ready():
	$Light2D.enabled = true
	$Light2D.energy = 0.7
	connect("visibility_changed", self, "_on_visibility_changed")
	connect("toggled", self, "_on_toggled")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_mouse or pressed:
		rect_scale = Vector2(1.3, 1)
	else:
		rect_scale = Vector2(1, 1)
	pass


func _on_DirectionArrow_mouse_entered():
	on_mouse = true
	pass # Replace with function body.


func _on_DirectionArrow_mouse_exited():
	on_mouse = false
	pass # Replace with function body.

func _on_toggled(is_pressed):
	if is_pressed:
		$Light2D.energy = 1.3
	else:
		$Light2D.energy = 0.7
func _on_visibility_changed():
	$Light2D.color = modulate
	if disabled or !visible:
		$Light2D.enabled = false
	if !disabled and visible:
		$Light2D.enabled = true
