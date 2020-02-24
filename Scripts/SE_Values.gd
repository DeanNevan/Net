extends Node2D

signal end
signal next

var type = Global.VALUE_TYPE.EGY
var start_position := Vector2()
var end_position := Vector2()
var length = Global.KEY_LENGTH
var direction = 0
var direction_vector := Vector2()
var is_ending := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.visible = false
	match direction:
		0:
			direction_vector = Vector2(1, 0)
		1:
			direction_vector = Vector2(1, 0)
		2:
			direction_vector = Vector2(-1, 0)
		3:
			direction_vector = Vector2(-1, 0)
	start_position = - direction_vector * length / 2
	position = start_position
	end_position = start_position + (direction_vector.normalized() * length)
	match type:
		Global.VALUE_TYPE.EGY:
			modulate = Global.BLUE_NODE_COLOR
		Global.VALUE_TYPE.ENT:
			modulate = Color(0.1, 0.1, 0.1, 1)
		Global.VALUE_TYPE.ORD:
			modulate = Global.GREEN_NODE_COLOR
		Global.VALUE_TYPE.BLANK:
			modulate = Color(1, 1, 1, 0.7)
	$Light2D.color = modulate
	$Light2D.mode = $Light2D.MODE_ADD
	if type == Global.VALUE_TYPE.ENT:
		$Light2D.mode = $Light2D.MODE_SUB
		#$Light2D.color = Color.black
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
