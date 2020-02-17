extends Area2D

signal done
signal update_ok

signal send_value(send_list)

var type = Global.KEY_TYPE.KEY
var location := Vector2()

var nodes := {}

var send_value_list := []
#[self, target, value_type, value_count]


#var EGY := 0#传输的能量值
#var ENT := 0#传输的熵值
#var ORD := 0#传输的秩序值

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("done", self, "_on_done")
	
	get_node("/root/Main").connect("keys_work", self, "work")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func work():
	emit_signal("send_value", send_value_list)
	pass

func _on_done():
	send_value_list = []
	pass

func _on_nodes_send_value(list : Array):
	var _arr := []
	for i in list:
		if i[1] == self:
			_arr.append(i)
	for i in _arr:
		var _nodes_arr = nodes.keys()
		_nodes_arr.erase(i[0])
		send_value_list.append([self, _nodes_arr[0], i[2], i[3]])

func update_nodes():
	if nodes.size() > 0:
		for i in nodes:
			if nodes[i].is_connected("send_value", self, "_on_nodes_send_value"):
				nodes[i].disconnect("send_value", self, "_on_nodes_send_value")
	
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		nodes = {}
		for i in areas:
			if i.has_method("update_keys"):
				if i.location.x > self.location.x:
					nodes[i] = 1
				elif i.location.y > self.location.y:
					nodes[i] = 2
				elif i.location.x < self.location.x:
					nodes[i] = 3
				else:
					nodes[i] = 4
	
	if nodes.size() > 0:
		for i in nodes:
			if !nodes[i].is_connected("send_value", self, "_on_nodes_send_value"):
				nodes[i].connect("send_value", self, "_on_nodes_send_value")
	
	emit_signal("update_ok")
	pass
