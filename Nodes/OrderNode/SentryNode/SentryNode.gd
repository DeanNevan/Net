extends "res://Scripts/OrderNode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Global.BLUE_NODE_COLOR
	type = Global.NODE_TYPE.ORD_NODE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	yield(get_tree(), "idle_frame")
	$Light2D.enabled = true
	for i in keys.keys():
		i.get_node("Light2D").enabled = true
	
	emit_signal("send_value", send_value_list)
	emit_signal("done")

func _on_Keys_work():
	$Light2D.enabled = false
	for i in keys.keys():
		i.get_node("Light2D").enabled = false
