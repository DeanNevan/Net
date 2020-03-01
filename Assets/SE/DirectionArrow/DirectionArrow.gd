extends TextureButton


var on_mouse = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
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
