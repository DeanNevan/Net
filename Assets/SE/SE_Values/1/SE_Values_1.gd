extends "res://Scripts/SE_Values.gd"



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(position)
	#print((end_position - position).length())
	if is_queued_for_deletion():
		return
	if !is_ending:
		position += Global.SE_Values_BASIC_SPEED * direction_vector
	if (end_position - position).length() <= 20:
		end()
	if (end_position - position).length() <= length / 2:
		emit_signal("next")
	pass

func start():
	$Sprite.visible = true

func end():
	is_ending = true
	emit_signal("end")
	queue_free()
