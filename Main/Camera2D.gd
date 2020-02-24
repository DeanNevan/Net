extends Camera2D

var min_zoom = 2
var max_zoom = 18

var Tween1 = Tween.new()

var controllable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	Tween1.interpolate_property(self, "zoom", zoom, Vector2(12, 12), 3.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	controllable = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	var _zoom
	if Input.is_action_just_released("wheel_up"):
		_zoom = clamp(zoom.x - 1.3, min_zoom, max_zoom)
	elif Input.is_action_just_released("wheel_down"):
		_zoom = clamp(zoom.x + 1.3, min_zoom, max_zoom)
	if _zoom != null and _zoom != zoom.x:
		smooth_zoom(Vector2(_zoom, _zoom))

func smooth_zoom(target_zoom):
	Tween1.stop_all()
	Tween1.interpolate_property(self, "zoom", zoom, target_zoom, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
