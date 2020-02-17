extends "res://Scripts/BasicNode.gd"

var super_entropy_value := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	type = Global.NODE_TYPE.ENT_NODE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	if ENT > 0:
		super_entropy_value += 1
	if randf() <= 0.5:
		var _jud = false
		for i in neighbor_nodes:
			if i.type == Global.NODE_TYPE.ORD_NODE:
				_jud = true#周围1格存在秩序节点
				break
		if !_jud:
			send_value_list.append([self,
									keys[randi() % keys.size()],
									Global.VALUE_TYPE.EGY,
									EGY]
								  )
	var neighbor_2_nodes = []
	for i1 in neighbor_nodes:
		for i2 in i1.neighbor_nodes:
			if !neighbor_2_nodes.has(i2):
				neighbor_2_nodes.append(i2)
	var _ord_nodes = []#1-2格内的秩序节点
	for i in neighbor_2_nodes:
		if i.type == Global.NODE_TYPE.ORD_NODE:
			_ord_nodes.append(i)
	for i in _ord_nodes:
		if neighbor_nodes.has(i):
			send_value_list.append([self, neighbor_nodes[i], Global.VALUE_TYPE.ENT, 2])
		else:
			for a in _ord_nodes.neighbor_nodes:
				if neighbor_nodes.has(a):
					send_value_list.append([self, neighbor_nodes[a], Global.VALUE_TYPE.ENT, 2])
	
	if ORD > 1:
		super_entropy_value -= ORD - 1
	
	super_entropy_value = clamp(super_entropy_value, 0, 10)
	emit_signal("send_value", send_value_list)
	pass

func get_send_value_list():
	if EGY > 0:
		var _keys_arr = keys
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.EGY:
				_source_arr.append(i[0])
		for i in _source_arr:
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() != 0:
			send_value_list.append([self,
									_keys_arr[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.EGY,
									EGY]
								  )
	if ENT > 0:
		var _keys_arr = keys
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.ENT:
				_source_arr.append(i[0])
		for i in _source_arr:
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() != 0:
			send_value_list.append([self,
									_keys_arr[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.ENT,
									ENT]
								  )
	if ORD > 0:
		var _keys_arr = keys
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.ORD:
				_source_arr.append(i[0])
		for i in _source_arr:
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() != 0:
			send_value_list.append([self,
									_keys_arr[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.ORD,
									ORD]
								  )
	return send_value_list
	pass
