extends "res://Scripts/BasicNode.gd"

signal turned

var intro = "非秩序节点：接收1能量，熵+1，接收1熵，熵+1，接收1秩序，熵-1"

var max_ev := 10
var entropy_value := 0

var modulate_array=[Color(0.94, 0.94, 0.94, 1),
					Color(0.86, 0.86, 0.86, 1),
					Color(0.78, 0.78, 0.78, 1),
					Color(0.70, 0.70, 0.70, 1),
					Color(0.62, 0.62, 0.62, 1),
					Color(0.54, 0.54, 0.54, 1),
					Color(0.46, 0.46, 0.46, 1),
					Color(0.38, 0.38, 0.38, 1),
					Color(0.30, 0.30, 0.30, 1),
					Color(0.22, 0.22, 0.22, 1)]
# Called when the node enters the scene tree for the first time.
func _ready():
	type = Global.NODE_TYPE.EMP_NODE
	add_to_group("EmptyNodes")
	#$CollisionShape2D2.disabled = true
	#$CollisionShape2D3.disabled = true
	#connect("area_entered", self, "_on_Area_entered")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_queued_for_deletion():
		return
	#if is_selected:
		#print(entropy_value)
	if on_mouse and Input.is_action_just_pressed("key_shift"):
		send_value_list.append([self, keys.keys()[randi() % keys.size()], Global.VALUE_TYPE.EGY, 2])
	modulate = modulate_array[clamp(entropy_value, 0, 9)]
	$Label.text = str(entropy_value) + "\n" + str(send_value_list) + "\n" + str($Light2D.enabled)
	pass

func work():
	if is_queued_for_deletion() or !is_instance_valid(self):
		return
	update_neighbor_nodes()
	
	#yield(get_tree(), "idle_frame")
	if send_value_list.size() > 0:
		turn_on_lights(true)
	#update_neighbor_nodes()
	if EGY > 0:
		entropy_value += 1
		EGY -= 1
	if ENT > 0:
		entropy_value += 1
		ENT -= 1
	if ORD > 0:
		entropy_value -= 1
	if entropy_value >= Global.MAX_ENT:
		turn_to_EntropyNode()
		return
	yield(get_tree(), "idle_frame")
	entropy_value = clamp(entropy_value, 0, Global.MAX_ENT)
	emit_signal("send_value", get_send_value_list())
	emit_signal("done")
	pass

func _on_Keys_work():
	#print("!!!")
	EGY = 0
	ENT = 0
	ORD = 0
	accepted_value = []
	send_value_list = []
	turn_off_lights()
#func _on_Area_entered(area):
	#pass

func get_send_value_list():
	if EGY > 0:
		var _keys_arr = keys
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.EGY:
				_source_arr.append(i[0])
		for i in _source_arr.size():
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() == 0:
			entropy_value += EGY
			EGY = 0
		else:
			send_value_list.append([self,
									_keys_arr.keys()[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.EGY,
									EGY]
								  )
	if ENT > 0:
		var _keys_arr = keys
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.ENT:
				_source_arr.append(i[0])
		for i in _source_arr.size():
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() == 0:
			entropy_value += ENT
			ENT = 0
		else:
			send_value_list.append([self,
									_keys_arr.keys()[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.ENT,
									ENT]
								  )
	if ORD > 0:
		var _keys_arr = keys
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.ORD:
				_source_arr.append(i[0])
		for i in _source_arr.size():
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() == 0:
			entropy_value -= ORD
			ORD = 0
		else:
			send_value_list.append([self,
									_keys_arr.keys()[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.ORD,
									ORD]
								  )
	return send_value_list
	pass

func turn_to_EntropyNode():
	print("turned!")
	emit_signal("turned", self)
	remove_from_group("EmptyNodes")
	remove_from_group("Nodes")
