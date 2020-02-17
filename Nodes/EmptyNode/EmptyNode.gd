extends "res://Scripts/BasicNode.gd"

var intro = "非秩序节点：接收1能量，熵+1，接收1熵，熵+1，接收1秩序，熵-1"
var entropy_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	type = Global.NODE_TYPE.EMP_NODE
	#$CollisionShape2D2.disabled = true
	#$CollisionShape2D3.disabled = true
	#connect("area_entered", self, "_on_Area_entered")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	if EGY > 0:
		entropy_value += 1
		EGY -= 1
	if ENT > 0:
		entropy_value += 1
		ENT -= 1
	if ORD > 0:
		entropy_value -= 1
	entropy_value = clamp(entropy_value, 0, Global.MAX_ENT)
	emit_signal("send_value", get_send_value_list())
	pass

#func _on_Area_entered(area):
	#pass

func get_send_value_list():
	if EGY > 0:
		var _keys_arr = keys
		var _source_arr = []
		for i in accepted_value:
			if i[2] == Global.VALUE_TYPE.EGY:
				_source_arr.append(i[0])
		for i in _source_arr:
			_keys_arr.erase(_source_arr[i])
		if _keys_arr.size() == 0:
			entropy_value += EGY
			EGY = 0
		else:
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
		if _keys_arr.size() == 0:
			entropy_value += ENT
			ENT = 0
		else:
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
		if _keys_arr.size() == 0:
			entropy_value -= ORD
			ORD = 0
		else:
			send_value_list.append([self,
									_keys_arr[randi() % _keys_arr.size()],
									Global.VALUE_TYPE.ORD,
									ORD]
								  )
	return send_value_list
	pass
