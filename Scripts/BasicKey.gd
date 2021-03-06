extends Area2D

signal done#信号：运作完成
signal update_ok

signal values_all_displayed#信号：数据全部发送完成

signal send_value(send_list)#信号：发送数据

signal selected#信号：选中
signal double_selected(key)#信号：双击选中
signal cancel_select#信号：取消选中
signal cancel_double_select(key)#信号：取消双击选中

var name_CN = "键"#中文名
var detail = ""#细节介绍
var introduction = "-This is a key to the truth"#充满逼格的话

var type = Global.KEY_TYPE.KEY#种类
var location#位置
var direction#方向

#连接的节点
var nodes := {}
var reverse_nodes := {}

var send_value_list := []#[self, target, value_type, value_count]

var round_send_value_list := []#本回合发送数值

var on_mouse := false
var is_selected := false
var is_double_selected := false

var is_working = false#是否运作中

var pollution = 0#受污染程度
var color = Color.black#颜色

#颜色数组，随pollution污染程度而改变
var modulate_array=[Color(0.9, 0.9, 0.9, 1),
					Color(0.7, 0.7, 0.7, 1),
					Color(0.5, 0.5, 0.5, 1),
					Color(0.1, 0.1, 0.1, 1),
					Color(0.05, 0.05, 0.05, 1)]

var sending_values = {}#{direction:[EGY, ENT, ORD]}

#var EGY := 0#传输的能量值
#var ENT := 0#传输的熵值
#var ORD := 0#传输的秩序值
var MainScene
var SelectedAnimation
onready var Tween1 = Tween.new()
onready var Icon = Sprite.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	SelectedAnimation = load("res://Assets/SE/NodesSelected/NodesSelected.tscn").instance()
	add_child(SelectedAnimation)
	SelectedAnimation.stop()
	SelectedAnimation.get_node("Sprite").visible = false
	connect("selected", self, "_on_selected")
	connect("double_selected", self, "_on_double_selected")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	if location != null and direction != null:
		set_position_with_location(location, direction)
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	connect("done", self, "_on_done")
	add_to_group("Keys")
	if MainScene != null:
		#MainScene.connect("Keys_work", self, "work")
		MainScene.connect("Nodes_work", self, "_on_Nodes_work")
		MainScene.connect("next_round", self, "_on_next_round")
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("left_mouse_button"):
		if on_mouse and is_selected:
			if !is_double_selected:
				emit_signal("double_selected", self)
			is_double_selected = true
		elif on_mouse and !is_selected:
			is_selected = true
			emit_signal("selected", self)
		elif !on_mouse:
			if is_selected:
				emit_signal("cancel_select", self)
			is_selected = false
	if event.is_action_pressed("right_mouse_button"):
		if is_double_selected:
			emit_signal("cancel_double_select", self)
		if is_selected:
			emit_signal("cancel_select", self)
		is_double_selected = false
		is_selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Light2D.energy == 0:
		$Light2D.enabled = false
	modulate = color
	if is_selected:
		SelectedAnimation.playback_speed = Global.time_speed
		SelectedAnimation.get_node("Sprite").visible = true
	else:
		SelectedAnimation.get_node("Sprite").visible = false

#运行一次
func work():
	for i in nodes:
		if !is_instance_valid(i):
			nodes.erase(i)
	is_working = true
	update_nodes()
	if send_value_list.size() > 0:
		turn_on_lights(true)
	#yield(get_tree(), "idle_frame")
	
	if send_value_list.size() > 0:
		if direction == nodes.values()[0]:
			display_values(sending_values[nodes.values()[0]], -1, direction)
			display_values(sending_values[nodes.values()[1]], 1, direction)
		else:
			display_values(sending_values[nodes.values()[0]], 1, direction)
			display_values(sending_values[nodes.values()[1]], -1, direction)
	#yield(get_tree(), "idle_frame")
	emit_signal("send_value", send_value_list)
	pass


func display_values(values_array := [0, 0, 0], direction1 = 0, key_direction = 0):
	var Node_direction = 0
	if direction1 == -1:
		Node_direction = direction
	elif direction1 == 1:
		match direction:
			0:
				Node_direction = 2
			1:
				Node_direction = 3
			2:
				Node_direction = 0
			3:
				Node_direction = 1
	for i in values_array[0]:
		var new_SE_EGY = Global.SE_EGY.instance()
		new_SE_EGY.direction = direction1
		new_SE_EGY.key_direction = key_direction
		new_SE_EGY.type = Global.VALUE_TYPE.EGY
		new_SE_EGY.connect("end", reverse_nodes[Node_direction], "_on_SE_EGY_arrived")
		add_child(new_SE_EGY)
		new_SE_EGY.start()
		yield(new_SE_EGY, "next")
	yield(get_tree(), "idle_frame")
	for i in values_array[1]:
		var new_SE_ENT = Global.SE_ENT.instance()
		new_SE_ENT.direction = direction1
		new_SE_ENT.key_direction = key_direction
		new_SE_ENT.type = Global.VALUE_TYPE.ENT
		new_SE_ENT.connect("end", reverse_nodes[Node_direction], "_on_SE_ENT_arrived")
		add_child(new_SE_ENT)
		new_SE_ENT.start()
		yield(new_SE_ENT, "next")
	yield(get_tree(), "idle_frame")
	for i in values_array[2]:
		var new_SE_ORD = Global.SE_ORD.instance()
		new_SE_ORD.direction = direction1
		new_SE_ORD.key_direction = key_direction
		new_SE_ORD.type = Global.VALUE_TYPE.ORD
		new_SE_ORD.connect("end", reverse_nodes[Node_direction], "_on_SE_ORD_arrived")
		add_child(new_SE_ORD)
		new_SE_ORD.start()
		yield(new_SE_ORD, "next")
	yield(get_tree(), "idle_frame")
	emit_signal("values_all_displayed")

func _on_Nodes_work():
	sending_values = {nodes.values()[0] : [0, 0, 0], nodes.values()[1] : [0, 0, 0]}
	send_value_list.clear()
	turn_off_lights(true)
	pass

func _on_next_round():
	round_send_value_list.clear()

func _on_done():
	pass

func _on_nodes_send_value(list):
	if list == null or list.size() == 0:
		return
	var _arr := []
	#print(list)
	for i in list:
		if i[1] == self:
			_arr.append(i)
	for i in _arr:
		var _nodes_arr = nodes.keys()
		_nodes_arr.erase(i[0])
		send_value_list.append([self, _nodes_arr[0], i[2], i[3]])
		match i[2]:
			Global.VALUE_TYPE.EGY:
				sending_values[nodes[_nodes_arr[0]]][0] += i[3]
			Global.VALUE_TYPE.ENT:
				sending_values[nodes[_nodes_arr[0]]][1] += i[3]
			Global.VALUE_TYPE.ORD:
				sending_values[nodes[_nodes_arr[0]]][2] += i[3]
	round_send_value_list = send_value_list.duplicate()

func update_nodes():
	"""nodes.clear()
	reverse_nodes.clear()
	if MainScene.Nodes.keys().has(Vector2(location.x + 0.5, location.y)):
		var node = MainScene.Keys[Vector2(location.x + 0.5, location.y)]
		nodes[node] = 0
		reverse_nodes[0] = node
	if MainScene.Nodes.keys().has(Vector2(location.x - 0.5, location.y)):
		var node = MainScene.Keys[Vector2(location.x - 0.5, location.y)]
		nodes[node] = 2
		reverse_nodes[2] = node
	if MainScene.Nodes.keys().has(Vector2(location.x, location.y + 0.5)):
		var node = MainScene.Keys[Vector2(location.x, location.y + 0.5)]
		nodes[node] = 1
		reverse_nodes[1] = node
	if MainScene.Nodes.keys().has(Vector2(location.x, location.y - 0.5)):
		var node = MainScene.Keys[Vector2(location.x, location.y - 0.5)]
		nodes[node] = 3
		reverse_nodes[3] = node"""
	
	if sending_values.size() == 0 and nodes.size() > 0:
		sending_values[nodes[nodes.keys()[0]]] = [0, 0, 0]
		sending_values[nodes[nodes.keys()[1]]] = [0, 0, 0]
	elif sending_values.size() == 1 and nodes.size() > 0:
		if sending_values.keys().has(nodes[nodes.keys()[0]]):
			sending_values[nodes[nodes.keys()[1]]] = [0, 0, 0]
		else:
			sending_values[nodes[nodes.keys()[0]]] = [0, 0, 0]

	if nodes.size() > 0:
		var _count = 0
		var c = Color(0, 0, 0, 0)
		for i in nodes:
			_count += 1
			if is_instance_valid(i):
				c += i.color
				if !i.is_connected("send_value", self, "_on_nodes_send_value"):
					i.connect("send_value", self, "_on_nodes_send_value")
			else:
				nodes.erase(i)
		color = c / _count
	emit_signal("update_ok")
	pass

func _on_area_entered(area):
	if area.has_method("update_keys"):
		if area.position.x > self.position.x:
			nodes[area] = 0
			reverse_nodes[0] = area
		elif area.position.y > self.position.y:
			nodes[area] = 1
			reverse_nodes[1] = area
		elif area.position.x < self.position.x:
			nodes[area] = 2
			reverse_nodes[2] = area
		else:
			nodes[area] = 3
			reverse_nodes[3] = area

func _on_area_exited(area):
	reverse_nodes.erase(area)
	return
	if area.has_method("update_keys"):
		reverse_nodes.erase(nodes[area])
		nodes.erase(area)

func set_position_with_location(location, direction):
	rotation_degrees = direction * 90
	global_position = location * (Global.NODE_RADIUS + (Global.KEY_LENGTH / 2)) * 2
	pass

func _on_selected(key):
	show_SelectedAnimation()

func _on_double_selected(key):
	pass

func show_SelectedAnimation():
	print("该键是", self)
	print("nodes", nodes)
	for i in nodes:
		if !is_instance_valid(i):
			print("有节点不合法")
	print("亮暗",$Light2D.enabled)
	print("direction", direction)
	print("___")
	SelectedAnimation.play("nodes_selected")
	SelectedAnimation.get_node("Sprite").position = position
	if type == Global.NODE_TYPE.ENT_NODE:
		SelectedAnimation.get_node("Sprite").modulate = Color.black
	else:
		SelectedAnimation.get_node("Sprite").modulate = color
	SelectedAnimation.get_node("Light2D").color = SelectedAnimation.get_node("Sprite").modulate
	SelectedAnimation.get_node("Light2D").visible = true
	SelectedAnimation.get_node("Sprite").visible = true

func _on_mouse_entered():
	on_mouse = true

func _on_mouse_exited():
	on_mouse = false

func turn_on_lights(spread = false):
	#yield(get_tree(), "idle_frame")
	$Light2D.enabled = true
	#Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.2, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	if spread:
		for i in nodes.keys():
			i.turn_on_lights()

func turn_off_lights(spread = false):
	#$Light2D.enabled = false
	#Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	#if spread:
		#for i in nodes.keys():
			#i.turn_off_lights()
