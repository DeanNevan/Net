extends TextureProgress

signal start

signal arrive_big_light
signal done
var on_mouse = false


var is_pressed = false

var is_done = false

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(value)
	if is_pressed:
		return
	if on_mouse and value == 100 and Input.is_action_just_released("left_mouse_button"):
		is_pressed = true
		start()
	#if !on_mouse and !Tween1.is_active():
		#Tween1.interpolate_property(self, "value", value, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#Tween1.start()
	$Light2D.energy = value / 100

func start():
	emit_signal("start")
	disconnect("mouse_entered", self, "_on_StartArrow_mouse_entered")
	disconnect("mouse_exited", self, "_on_StartArrow_mouse_exited")
	get_parent().enable_camera = true
	Tween1.interpolate_property(self, "rect_position", rect_position, rect_position - Vector2(50, -167), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(get_tree().create_timer(0.5), "timeout")
	Tween1.stop_all()
	Tween1.interpolate_property(self, "rect_position", rect_position, rect_position + Vector2(4540, 0), 3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(get_tree().create_timer(3.1), "timeout")
	Tween1.stop_all()
	
	yield(get_parent(), "generate_done")
	
	emit_signal("arrive_big_light")
	rect_position += Vector2(0, 90)
	
	visible = false
	yield(get_parent().get_node("BigLight"), "disappeared")
	is_done = true
	pass

func is_ok():
	if is_done:
		emit_signal("done")

func _on_StartArrow_mouse_entered():
	Tween1.remove_all()
	Tween1.interpolate_property(self, "value", value, 100, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	on_mouse = true
	pass # Replace with function body.


func _on_StartArrow_mouse_exited():
	Tween1.remove_all()
	Tween1.interpolate_property(self, "value", value, 0, 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	on_mouse = false
	pass # Replace with function body.
