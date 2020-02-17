extends Area2D

signal done
signal update_ok
signal send_value(send_list)

var type = Global.NODE_TYPE.EMP_NODE

var keys := {}
var neighbor_nodes := {}#{节点 : 连接的键}

var location := Vector2()

var accepted_value := []
#[[key, value_type, value_count]]

var send_value_list := []
#[[self, key, value_type, value_count]]

var EGY := 0
var ENT := 0
var ORD := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Main").connect("nodes_work", self, "work")
	connect("done", self, "_on_done")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	pass

func _on_done():
	EGY = 0
	ENT = 0
	ORD = 0
	accepted_value = []
	send_value_list = []
	pass

func _on_keys_send_value(list : Array):
	var _arr = []
	for i in list:
		if i[1] == self:
			_arr.append(i)
	if _arr.size() > 0:
		for i in _arr:
			accepted_value.append([i[0], i[2], i[3]])
			match i[2]:
				Global.VALUE_TYPE.EGY:
					EGY += i[3]
				Global.VALUE_TYPE.ENT:
					ENT += i[3]
				Global.VALUE_TYPE.ORD:
					ORD += i[3]
	pass

func update_keys():
	$CollisionShape2D2.disabled = false
	$CollisionShape2D3.disabled = false
	
	if keys.size() > 0:
		for i in keys:
			if keys[i].is_connected("send_value", self, "_on_keys_send_value"):
				keys[i].disconnect("send_value", self, "_on_keys_send_value")
	
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		keys = {}
		for i in areas:
			if i.has_method("update_nodes"):
				if i.location.x > self.location.x:
					keys[i] = 1
				elif i.location.y > self.location.y:
					keys[i] = 2
				elif i.location.x < self.location.x:
					keys[i] = 3
				else:
					keys[i] = 4
	
	if keys.size() > 0:
		for i in keys:
			if !keys[i].is_connected("send_value", self, "_on_keys_send_value"):
				keys[i].connect("send_value", self, "_on_keys_send_value")
	
	emit_signal("update_ok")
	yield(get_tree(), "idle_frame")
	update_neighbor_nodes()

func update_neighbor_nodes():
	neighbor_nodes = {}
	for i in keys.keys():
		var _arr = i.nodes
		_arr.erase(self)
		neighbor_nodes[_arr[0]] = i
