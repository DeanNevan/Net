extends Node2D


var location := Vector2()
var direction := 0

onready var Tween1 = Tween.new()
onready var Tween2 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	add_child(Tween2)
	live_light()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func live_light():
	while true:
		Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.3, 1.6, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		Tween1.start()
		yield(Tween1, "tween_completed")
		Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0.8, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
		Tween1.start()
		yield(Tween1, "tween_completed")

func set_position_with_location(new_location, new_direction):
	rotation_degrees = new_direction * 90
	global_position = new_location * (Global.NODE_RADIUS + (Global.KEY_LENGTH / 2)) * 2

func smooth_change_color(target_color, change_speed = 0.5):
	Tween2.interpolate_property(self, "modulate", modulate, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween2.interpolate_property($Light2D, "color", $Light2D.color, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween2.start()
