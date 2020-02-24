extends TextureProgress


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

func change_value(target_value):
	Tween1.interpolate_property(self, "value", value, target_value, 0.4, Tween.TRANS_LINEAR,Tween.EASE_IN)
	Tween1.start()
