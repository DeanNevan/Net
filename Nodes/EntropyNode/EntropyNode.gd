extends "res://Scripts/BasicNode.gd"

signal destroyed

var max_sev := 10
var super_entropy_value := 1


# Called when the node enters the scene tree for the first time.
func _ready():
	color = Color.black
	name_CN = "熵节点"
	type = Global.NODE_TYPE.ENT_NODE
	add_to_group("EntropyNodes")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(send_value_list) + "\n" + str($Light2D.enabled)
	pass

func work():
	if is_queued_for_deletion() or !is_instance_valid(self):
		return
	update_keys()
	update_neighbor_nodes()
	#update_neighbor_nodes()
	if send_value_list.size() > 0:
		turn_on_lights(true, 1.2)
	super_entropy_value += 1
	if EGY > 0:
		super_entropy_value += 1
		EGY = 0
	if is_selected:
		print("___work___")
		print("接受数值：", accepted_value)
	var _jud = false
	var emp_nodes = []
	for i in neighbor_nodes:
		if i.type == Global.NODE_TYPE.ORD_NODE:
			if is_selected:
				print("周围1格存在秩序节点")
			_jud = true#周围1格存在秩序节点
		if i.type == Global.NODE_TYPE.EMP_NODE:
			emp_nodes.append(i)
	if !_jud and keys.size() > 0 and emp_nodes.size() > 0:
		if randf() <= 0.5:
			var _ran = emp_nodes[randi() % emp_nodes.size()]
			send_value_list.append([self,
									neighbor_nodes[_ran],
									Global.VALUE_TYPE.ENT,
									1]
								  )
	var _ord_nodes = []
	for i in neighbor_nodes.keys():
		if is_instance_valid(i):
			if i.type == Global.NODE_TYPE.ORD_NODE:
				_ord_nodes.append(i)
	for i in _ord_nodes:
		send_value_list.append([
			self,
			neighbor_nodes[i],
			Global.VALUE_TYPE.ENT,
			1
		])
	if ORD > 1:
		super_entropy_value -= ORD - 1
		ORD = 0
	get_send_value_list()
	if super_entropy_value <= 0:
		destroyed(abs(super_entropy_value))
		return
	super_entropy_value = clamp(super_entropy_value, 0, max_sev)
	yield(get_tree(), "idle_frame")
	if is_selected:
		print("发送数值：", send_value_list)
		print("___end___")
	emit_signal("send_value", send_value_list)
	emit_signal("done")
	pass

func get_send_value_list():
	if EGY > 0:
		var _keys_arr = keys.duplicate()
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.EGY:
				_source_arr.append(i[0])
		for i in _source_arr.size():
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() != 0:
			send_value_list.append([self,
									_keys_arr.keys()[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.EGY,
									EGY]
								  )
	#yield(get_tree(), "idle_frame")
	if ENT > 0:
		var _keys_arr = keys.duplicate()
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.ENT:
				_source_arr.append(i[0])
		for i in _source_arr.size():
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() != 0:
			send_value_list.append([self,
									_keys_arr.keys()[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.ENT,
									ENT]
								  )
	#yield(get_tree(), "idle_frame")
	if ORD > 0:
		var _keys_arr = keys.duplicate()
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.ORD:
				_source_arr.append(i[0])
		for i in _source_arr.size():
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() != 0:
			send_value_list.append([self,
									_keys_arr.keys()[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.ORD,
									ORD]
								  )
	pass

func _on_Keys_work():
	EGY = 0
	ENT = 0
	ORD = 0
	accepted_value = []
	send_value_list = []
	turn_off_lights()

func get_damage(value):
	pass

func destroyed(accepted_ORD):
	emit_signal("destroyed", self, accepted_ORD)
	remove_from_group("EntropyNodes")
	remove_from_group("Nodes")
