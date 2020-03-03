extends RichTextLabel

signal disappeared

var is_displaying = false


onready var Tween1 = Tween.new()

func _ready():
	visible_characters = 0
	add_child(Tween1)
	Tween1.interpolate_property($ColorRect, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	yield(Tween1, "tween_completed")
	display()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func display():
	while visible_characters < 1000:
		yield(get_tree().create_timer(0.03), "timeout")
		#print("plus!!!")
		visible_characters += 1

func disappear():
	Tween1.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	yield(Tween1, "tween_completed")
	emit_signal("disappeared")
