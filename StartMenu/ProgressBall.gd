extends TextureProgress

var on_mouse := false
var target_value = value

var wheel_count = 0

onready var Tween1 := Tween.new()
onready var maichongTimer = Timer.new()
var can_maichong = true
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(maichongTimer)
	maichongTimer.connect("timeout", self, "_on_maichongTimer_timeout")
	add_child(Tween1)
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_mouse:
		if Input.is_action_just_released("wheel_up"):
			set_value(value + 1)
		if Input.is_action_just_released("wheel_down"):
			set_value(value - 1)
		if Input.is_action_pressed("left_mouse_button"):
			set_value(((400 - (get_global_mouse_position().y - rect_position.y)) / 400) * max_value)

func set_value(target_value):
	Tween1.stop_all()
	Tween1.interpolate_property(self, "value", value, target_value, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()

func _on_maichongTimer_timeout():
	can_maichong = true

func _on_mouse_entered():
	on_mouse = true
	pass

func _on_mouse_exited():
	on_mouse = false
	pass
