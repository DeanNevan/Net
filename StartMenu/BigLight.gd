extends Sprite

signal disappeared

onready var Tween1 = Tween.new()
onready var Tween2 = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	add_child(Tween2)
	get_parent().get_node("StartArrow").connect("arrive_big_light", self, "disapear")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func disapear():
	yield(get_tree().create_timer(0.4), "timeout")
	Tween1.interpolate_property(self, "scale", scale, Vector2(), 1.6, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween2.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 2.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	Tween2.start()
	yield(get_tree().create_timer(2.3), "timeout")
	emit_signal("disappeared")
