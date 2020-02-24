extends "res://Scripts/OrderNode.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Global.GREEN_NODE_COLOR
	max_ov = 3
	order_value = 3
	type = Global.NODE_TYPE.ORD_NODE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	if is_queued_for_deletion() or !is_instance_valid(self):
		return
	update_neighbor_nodes()
	if send_value_list.size() > 0:
		turn_on_lights()
	if is_building:
		build()
	if is_building:
		return
	if ENT > 0:
		order_value -= ENT
		ENT = 0
	if order_value <= 0:
		destroyed(abs(order_value))
	var _temp := false
	for i in neighbor_nodes:
		if i.type == Global.NODE_TYPE.ENT_NODE:
			if i.type == Global.NODE_TYPE.EMP_NODE:
				if i.entropy_value > 0:
					_temp = true
	if !_temp:
		send_value_list.append([self, reverse_keys[direction], Global.VALUE_TYPE.EGY, 1])
	emit_signal("send_value", send_value_list)
	emit_signal("done")
	pass

func _on_Keys_work():
	EGY = 0
	ENT = 0
	ORD = 0
	accepted_value = []
	send_value_list = []
	turn_off_lights()
