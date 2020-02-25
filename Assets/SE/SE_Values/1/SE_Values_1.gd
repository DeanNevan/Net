extends "res://Scripts/SE_Values.gd"

var is_started = false


onready var Tween1 = Tween.new()
func _ready():
	add_child(Tween1)
	modulate.a = 0
	$Light2D.energy = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(position)
	#print((end_position - position).length())
	if is_queued_for_deletion() or !is_started:
		return
	if !is_ending:
		position += Global.SE_Values_BASIC_SPEED * direction_vector * Global.time_speed
	if (position - start_position).length() > length:
		end()
	if (position - start_position).length() > length / 2:
		emit_signal("next")
	pass

func start():
	$Sprite.visible = true
	Tween1.interpolate_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), Color(modulate.r, modulate.g, modulate.b, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "energy", 0, 3, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	is_started = true

func end():
	Tween1.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, 0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	is_ending = true
	emit_signal("end")
	yield(Tween1, "tween_completed")
	queue_free()
