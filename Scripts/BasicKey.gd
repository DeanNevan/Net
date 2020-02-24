extends Area2D

signal done
signal update_ok

signal values_all_displayed

signal send_value(send_list)

signal selected
signal double_selected
signal cancel_select
signal cancel_double_select

var type = Global.KEY_TYPE.KEY
var location
var direction

var nodes := {}
var reverse_nodes := {}

var send_value_list := []
#[self, target, value_type, value_count]

var on_mouse := false
var is_selected := false
var is_double_selected := false

#var EGY := 0#传输的能量值
#var ENT := 0#传输的熵值
#var ORD := 0#传输的秩序值
var MainScene
var SelectedAnimation
# Called when the node enters the scene tree for the first time.
func _ready():
	SelectedAnimation = load("res://Assets/SE/NodesSelected/NodesSelected.tscn").instance()
	add_child(SelectedAnimation)
	SelectedAnimation.stop()
	SelectedAnimation.get_node("Sprite").visible = false
	connect("selected", self, "show_SelectedAnimation")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	if location != null and direction != null:
		set_position_with_location(location, direction)
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	connect("done", self, "_on_done")
	add_to_group("Keys")
	if MainScene != null:
		MainScene.connect("Keys_work", self, "work")
		MainScene.connect("Nodes_work", self, "_on_Nodes_work")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_mouse and Input.is_action_just_pressed("left_mouse_button"):
		is_selected = true
		emit_signal("selected")
	if !on_mouse and Input.is_action_just_pressed("left_mouse_button"):
		is_selected = false
		emit_signal("cancel_select")
	if is_selected and Input.is_action_just_pressed("left_mouse_button"):
		emit_signal("double_selected")
		is_double_selected = true
	#if !is_double_selected and !on_mouse and Input.is_action_just_pressed("left_mouse_button"):
		#is_selected = false
		#emit_signal("cancel_select")
	if Input.is_action_just_pressed("right_mouse_button"):
		is_double_selected = false
		is_selected = false
		emit_signal("cancel_double_select")
		emit_signal("cancel_select")
	if is_selected:
		SelectedAnimation.get_node("Sprite").visible = true
	else:
		SelectedAnimation.get_node("Sprite").visible = false

func work():
	yield(get_tree(), "idle_frame")
	$Light2D.enabled = true
	for i in nodes.keys():
		i.get_node("Light2D").enabled = true
	var send_values = {}
	for i in send_value_list:
		if send_values.keys().has(nodes[i[1]]):
			send_values[nodes[i[1]]][i[2]] += i[3]
		else:
			send_values[nodes[i[1]]] = {Global.VALUE_TYPE.EGY : 0, Global.VALUE_TYPE.ENT : 0, Global.VALUE_TYPE.ORD : 0}
	if send_values.keys().size() == 1:
		display_values([send_values[send_values.keys()[0]][Global.VALUE_TYPE.EGY], send_values[send_values.keys()[0]][Global.VALUE_TYPE.ENT], send_values[send_values.keys()[0]][Global.VALUE_TYPE.ORD]], send_values[send_values.keys()[0]])
	elif send_values.keys().size() == 2:
		display_values([send_values[send_values.keys()[0]][Global.VALUE_TYPE.EGY], send_values[send_values.keys()[0]][Global.VALUE_TYPE.ENT], send_values[send_values.keys()[0]][Global.VALUE_TYPE.ORD]], send_values[send_values.keys()[0]])
		display_values([send_values[send_values.keys()[1]][Global.VALUE_TYPE.EGY], send_values[send_values.keys()[1]][Global.VALUE_TYPE.ENT], send_values[send_values.keys()[1]][Global.VALUE_TYPE.ORD]], send_values[send_values.keys()[1]])
	
	
	emit_signal("send_value", send_value_list)
	emit_signal("done")
	pass

func display_values(values_array := [0, 0, 0], direction = 0, direction_vector := Vector2(1, 0)):
	for i in values_array[0]:
		var new_SE_EGY = Global.SE_EGY.instance()
		new_SE_EGY.direction = direction
		new_SE_EGY.direction_vector = direction_vector
		new_SE_EGY.type = Global.VALUE_TYPE.EGY
		new_SE_EGY.key_global_position = global_position
		add_child(new_SE_EGY)
		new_SE_EGY.start()
		yield(new_SE_EGY, "next")
	for i in values_array[1]:
		var new_SE_ENT = Global.SE_ENT.instance()
		new_SE_ENT.direction = direction
		new_SE_ENT.direction_vector = direction_vector
		new_SE_ENT.type = Global.VALUE_TYPE.ENT
		new_SE_ENT.key_global_position = global_position
		add_child(new_SE_ENT)
		new_SE_ENT.start()
		yield(new_SE_ENT, "next")
	for i in values_array[2]:
		var new_SE_ORD = Global.SE_ORD.instance()
		new_SE_ORD.direction = direction
		new_SE_ORD.direction_vector = direction_vector
		new_SE_ORD.type = Global.VALUE_TYPE.ORD
		new_SE_ORD.key_global_position = global_position
		add_child(new_SE_ORD)
		new_SE_ORD.start()
		yield(new_SE_ORD, "next")
	emit_signal("values_all_displayed")

func _on_Nodes_work():
	$Light2D.enabled = false
	for i in nodes.keys():
		i.get_node("Light2D").enabled = false

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
			if is_instance_valid(i):
				if i.is_connected("send_value", self, "_on_nodes_send_value"):
					i.disconnect("send_value", self, "_on_nodes_send_value")
			else:
				nodes.erase(i)
	
	var pollution = 0
	if nodes.size() > 0:
		for i in nodes:
			if is_instance_valid(i):
				if !i.is_connected("send_value", self, "_on_nodes_send_value"):
					i.connect("send_value", self, "_on_nodes_send_value")
				if i.type == Global.NODE_TYPE.ENT_NODE:
					pollution += 2
				elif i.type == Global.NODE_TYPE.EMP_NODE:
					pollution += 1
			else:
				nodes.erase(i)
	var modulate_array=[Color(0.9, 0.9, 0.9, 1),
						Color(0.7, 0.7, 0.7, 1),
						Color(0.5, 0.5, 0.5, 1),
						Color(0.3, 0.3, 0.3, 1),
						Color(0.1, 0.1, 0.1, 1)]
	modulate = modulate_array[pollution]
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
	if area.has_method("update_keys"):
		reverse_nodes.erase(nodes[area])
		nodes.erase(area)

func set_position_with_location(location, direction):
	rotation_degrees = direction * 90
	global_position = location * (Global.NODE_RADIUS + (Global.KEY_LENGTH / 2)) * 2
	pass

func show_SelectedAnimation():
	print("该键是", self)
	print("nodes", nodes)
	print("___")
	SelectedAnimation.play("nodes_selected")
	SelectedAnimation.get_node("Sprite").position = position
	SelectedAnimation.get_node("Sprite").modulate = modulate
	SelectedAnimation.get_node("Sprite").visible = true

func _on_mouse_entered():
	on_mouse = true

func _on_mouse_exited():
	on_mouse = false
