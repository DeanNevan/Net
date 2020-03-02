extends "res://Scripts/BasicNode.gd"

signal destroyed

var max_sev := 10
var super_entropy_value := 1


# Called when the node enters the scene tree for the first time.
func _ready():
	color = Color.black
	name_CN = "熵节点"
	detail = "-接收并消耗【x能量】：超熵值+1" + "\n"
	detail += "-接收并消耗【x秩序】：超熵值-（x-1）" + "\n"
	detail += "-接收并消耗【x熵】：超熵值+1" + "\n"
	detail += "-若全方向1格无秩序节点，50%概率 向 随机方向 发送【1熵】" + "\n"
	detail += "-若全方向1-2格有秩序节点，向有秩序节点的方向发送 【2熵】" + "\n"
	detail += "-若全方向均为熵节点，20%概率 向 随机方向 发送【1熵】"
	introduction = "熵寂是生命的末日"
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
	if ENT > 0:
		super_entropy_value += 1
		ENT = 0
	var _jud = false
	var emp_nodes = []
	for i in neighbor_nodes:
		if i.type == Global.NODE_TYPE.ORD_NODE:
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
	
	var _all_ent_Node = true
	for i in neighbor_nodes:
		if i.type != Global.NODE_TYPE.ENT_NODE:
			_all_ent_Node = false
			break
	if _all_ent_Node and randf() <= 0.2:
		send_value_list.append([self, keys.keys()[randi() % keys.size()], Global.VALUE_TYPE.ENT, 1])
	
	if ORD > 1:
		super_entropy_value -= ORD - 1
		ORD = 0
	get_send_value_list()
	if super_entropy_value <= 0:
		destroyed(abs(super_entropy_value))
		return
	super_entropy_value = clamp(super_entropy_value, 0, max_sev)
	get_send_value_list()
	round_send_value_list = send_value_list.duplicate()
	emit_signal("send_value", send_value_list)
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

func _on_next_round():
	round_accepted_value.clear()
	round_send_value_list.clear()

func get_damage(value):
	pass

func destroyed(accepted_ORD):
	emit_signal("destroyed", self, accepted_ORD)
	remove_from_group("EntropyNodes")
	remove_from_group("Nodes")
