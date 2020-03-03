extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func smooth_zoom(target_zoom, speed = 0.35):
	#Tween1.stop_all()
	Tween1.interpolate_property(self, "zoom", zoom, target_zoom, speed, Tween.TRANS_CIRC, Tween.EASE_OUT)
	Tween1.start()
