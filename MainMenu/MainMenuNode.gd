extends Node2D

signal selected(node)

var location := Vector2()

var on_mouse = false

onready var Tween1 = Tween.new()
onready var Tween2 = Tween.new()
func _ready():
	add_child(Tween1)
	add_child(Tween2)
	live_light()
	#$Area2D.connect("mouse_entered", self, "_on_mouse_entered")
	#$Area2D.connect("mouse_exited", self, "_on_mouse_exited")

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func live_light():
	while true:
		Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.6, 1.6, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		Tween1.start()
		yield(Tween1, "tween_completed")
		Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0.9, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
		Tween1.start()
		yield(Tween1, "tween_completed")
	pass

func _on_mouse_entered():
	on_mouse = true

func _on_mouse_exited():
	on_mouse = false

func set_position_with_location(new_location):
	global_position = new_location * (Global.NODE_RADIUS * 2 + Global.KEY_LENGTH)

func smooth_change_color(target_color, change_speed = 0.5):
	Tween2.interpolate_property(self, "modulate", modulate, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween2.interpolate_property($Light2D, "color", $Light2D.color, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween2.start()
