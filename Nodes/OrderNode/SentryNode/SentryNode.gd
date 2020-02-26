extends "res://Scripts/OrderNode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "哨兵节点"
	modulate = Global.BLUE_NODE_COLOR
	type = Global.NODE_TYPE.ORD_NODE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	if is_queued_for_deletion() or !is_instance_valid(self):
		return
	if send_value_list.size() > 0:
		turn_on_lights()
	update_neighbor_nodes()
	emit_signal("send_value", send_value_list)
	emit_signal("done")

func _on_Keys_work():
	EGY = 0
	ENT = 0
	ORD = 0
	accepted_value = []
	send_value_list = []
	turn_off_lights()
