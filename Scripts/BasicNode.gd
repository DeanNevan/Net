extends Area2D

signal done#信号：运作完成
signal update_ok
signal send_value(send_list)#信号：发送数据
signal selected(node)#信号：被选中
signal double_selected(node)#信号：被双击选中
signal cancel_select(node)#信号：取消选中
signal cancel_double_select(node)#信号：取消双击选中

var on_mouse := false#鼠标是否放在范围内
var is_selected := false#是否被选中
var is_double_selected := false#是否被双击选中

var name_CN = "节点"#中文名

#细节介绍
var detail = "-这是细节介绍"

var introduction = "-这是骚话"#有逼格的描述

var type = Global.NODE_TYPE.EMP_NODE#种类

#连接的键
var keys := {}
var reverse_keys := {}

#邻节点{节点 : 连接的键}
var neighbor_nodes := {}

#位置
var location := Vector2()

#接收的数据[[key, value_type, value_count]]
var accepted_value := []


#发送的数据[[self, key, value_type, value_count]]
var send_value_list := []


#本回合的接收、发送的数值
var round_accepted_value := []
var round_send_value_list := []

var EGY := 0#一回合内收到的能量总和
var ENT := 0#一回合内收到的熵总和
var ORD := 0#一回合内收到的秩序总和

var color = Color.blue#颜色，用于对一些特定元素赋予与节点相匹配的颜色

var MainScene#主场景
var SelectedAnimation#选中动画效果
onready var Tween1 = Tween.new()
onready var Icon = Sprite.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	
	SelectedAnimation = load("res://Assets/SE/NodesSelected/NodesSelected.tscn").instance()
	set_position_with_location(location)
	
	$CollisionShape2D.shape.radius = Global.NODE_RADIUS
	$CollisionShape2D2.shape.extents.x = Global.NODE_RADIUS+ 50
	$CollisionShape2D2.shape.extents.y = 10
	$CollisionShape2D3.shape.extents.x = 10
	$CollisionShape2D3.shape.extents.y = Global.NODE_RADIUS + 50
	add_child(SelectedAnimation)
	SelectedAnimation.stop()
	SelectedAnimation.get_node("Sprite").visible = false
	if MainScene != null:
		#MainScene.connect("Nodes_work", self, "work")
		MainScene.connect("Keys_work", self, "_on_Keys_work")
		MainScene.connect("next_round", self, "_on_next_round")
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	connect("done", self, "_on_done")
	add_to_group("Nodes")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("selected", self, "_on_selected")
	connect("double_selected", self, "_on_double_selected")
	pass

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
func _process(delta):
	#if is_selected:
		#print(introduction)
	if $Light2D.energy == 0:
		$Light2D.enabled = false
	#if !is_double_selected and !on_mouse and Input.is_action_just_pressed("left_mouse_button"):
		#is_selected = false
		#emit_signal("cancel_select")
	if is_selected:
		#SelectedAnimation.get_node("Sprite").visible = true
		SelectedAnimation.playback_speed = Global.time_speed
	else:
		SelectedAnimation.get_node("Sprite").visible = false
		SelectedAnimation.get_node("Light2D").visible = false

func work():
	pass

func _on_Keys_work():
	pass

func _on_next_round():
	pass

func _on_done():
	pass

func _on_keys_send_value(list : Array):
	if list.size() == 0 or list == null:
		return
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
	round_accepted_value = accepted_value.duplicate()

func _on_selected(node):
	show_SelectedAnimation()

func _on_double_selected(node):
	pass

#显示选择效果动画
func show_SelectedAnimation():
	print("该节点是", self)
	print("neighbor_nodes", neighbor_nodes)
	print("keys", keys)
	print("type", type)
	print("亮暗",$Light2D.enabled)
	print("___")
	#update_neighbor_nodes()
	SelectedAnimation.play("nodes_selected")
	SelectedAnimation.get_node("Sprite").position = position
	SelectedAnimation.get_node("Light2D").position = position
	if type == Global.NODE_TYPE.ENT_NODE:
		SelectedAnimation.get_node("Sprite").modulate = Color.black
	else:
		SelectedAnimation.get_node("Sprite").modulate = color
	SelectedAnimation.get_node("Light2D").color = SelectedAnimation.get_node("Sprite").modulate
	SelectedAnimation.get_node("Light2D").visible = true
	SelectedAnimation.get_node("Sprite").visible = true

#更新连接键
func update_keys():
	if keys.size() > 0:
		for i in keys:
			if is_instance_valid(i):
				if !i.is_connected("send_value", self, "_on_keys_send_value"):
					i.connect("send_value", self, "_on_keys_send_value")
			else:
				keys.erase(i)
	
	#update_neighbor_nodes()

#更新邻节点
func update_neighbor_nodes():
	neighbor_nodes = {}
	for i in keys:
		var _arr = i.nodes.keys()
		_arr.erase(self)
		if _arr.size() > 0:
			if is_instance_valid(_arr[0]):
				neighbor_nodes[_arr[0]] = i
	emit_signal("update_ok")

func _on_area_entered(area):
	if area.has_method("update_nodes"):
		if area.position.x > self.position.x:
			keys[area] = 0
			reverse_keys[0] = area
		elif area.position.y > self.position.y:
			keys[area] = 1
			reverse_keys[1] = area
		elif area.position.x < self.position.x:
			keys[area] = 2
			reverse_keys[2] = area
		else:
			keys[area] = 3
			reverse_keys[3] = area

func _on_area_exited(area):
	#if area.has_method("update_nodes"):
		#reverse_keys.erase(keys[area])
		#keys.erase(area)
	pass

#用location设置位置
func set_position_with_location(location):
	global_position = location * (Global.NODE_RADIUS * 2 + Global.KEY_LENGTH)

func _on_SE_EGY_arrived():
	#var _modulate = modulate
	Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.6, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "color", $Light2D.color, Color(0.33, 0.84, 1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "color", $Light2D.color, color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	pass

func _on_SE_ENT_arrived():
	#var _modulate = modulate
	Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.6, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "color", $Light2D.color, Color(0.1, 0.1, 0.1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "color", $Light2D.color, color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	pass

func _on_SE_ORD_arrived():
	#var _modulate = modulate
	Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.6, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "color", $Light2D.color, Color(0.5, 1, 0.4, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "color", $Light2D.color, color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	pass

func _on_mouse_entered():
	on_mouse = true

func _on_mouse_exited():
	on_mouse = false

func turn_on_lights(spread = false, target_energy = 1.2):
	#yield(get_tree(), "idle_frame")
	$Light2D.enabled = true
	#Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, target_energy, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	if spread:
		for i in keys.keys():
			i.turn_on_lights()

func turn_off_lights(spread = false):
	#$Light2D.enabled = false
	#Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	#if spread:
		#for i in keys.keys():
			#i.turn_off_lights()
