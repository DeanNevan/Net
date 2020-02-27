extends Camera2D

var min_zoom = 2
var max_zoom = 18

var Tween1 = Tween.new()

var controllable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	Tween1.interpolate_property(self, "zoom", zoom, Vector2(10, 10), 2.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	Tween1.start()
	yield(Tween1, "tween_completed")
	controllable = true
	pass # Replace with function body.

func _unhandled_input(event):
	var _zoom
	if event.is_action_released("wheel_up"):
		_zoom = clamp(zoom.x - 1.2, min_zoom, max_zoom)
		
	elif event.is_action_released("wheel_down"):
		_zoom = clamp(zoom.x + 1.2, min_zoom, max_zoom)
		
	if _zoom != null and _zoom != zoom.x:
		if _zoom < zoom.x:
			position += (get_global_mouse_position() - position) / 8
		else:
			position -= (get_global_mouse_position() - position) / 8
		smooth_zoom(Vector2(_zoom, _zoom))

func _process(delta):
	if !controllable:
		return
	var vec = Vector2()
	if Input.is_key_pressed(KEY_W):
		vec += Vector2(0, -10)
	if Input.is_key_pressed(KEY_A):
		vec += Vector2(-10, 0)
	if Input.is_key_pressed(KEY_S):
		vec += Vector2(0, 10)
	if Input.is_key_pressed(KEY_D):
		vec += Vector2(10, 0)
	position += vec * zoom
	

func smooth_zoom(target_zoom, speed = 0.35):
	Tween1.stop_all()
	Tween1.interpolate_property(self, "zoom", zoom, target_zoom, speed, Tween.TRANS_CIRC, Tween.EASE_OUT)
	Tween1.start()
