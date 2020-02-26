extends Area2D

signal done
signal update_ok
signal send_value(send_list)
signal selected
signal double_selected(node)
signal cancel_select
signal cancel_double_select(node)

var on_mouse := false
var is_selected := false
var is_double_selected := false

var name_CN = "节点"

var type = Global.NODE_TYPE.EMP_NODE

var keys := {}
var reverse_keys := {}
var neighbor_nodes := {}#{节点 : 连接的键}

var location := Vector2()

var accepted_value := []
#[[key, value_type, value_count]]

var send_value_list := []
#[[self, key, value_type, value_count]]

var EGY := 0
var ENT := 0
var ORD := 0

var MainScene
var SelectedAnimation
onready var Tween1 = Tween.new()
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
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	connect("done", self, "_on_done")
	add_to_group("Nodes")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("selected", self, "_on_selected")
	#connect("double_selected", self, "_on_double_selected")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Light2D.energy == 0:
		$Light2D.enabled = false
	if Input.is_action_just_pressed("left_mouse_button"):
		if on_mouse and is_selected:
			emit_signal("double_selected", self)
			is_double_selected = true
		elif on_mouse and !is_selected:
			is_selected = true
			emit_signal("selected")
		elif !on_mouse:
			is_selected = false
			emit_signal("cancel_select")
	#if !is_double_selected and !on_mouse and Input.is_action_just_pressed("left_mouse_button"):
		#is_selected = false
		#emit_signal("cancel_select")
	if Input.is_action_just_pressed("right_mouse_button"):
		is_double_selected = false
		is_selected = false
		emit_signal("cancel_double_select", self)
		emit_signal("cancel_select")
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
	pass

func _on_selected():
	show_SelectedAnimation()

func _on_double_seleted(node):
	pass

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
		SelectedAnimation.get_node("Sprite").modulate = modulate
	SelectedAnimation.get_node("Light2D").color = SelectedAnimation.get_node("Sprite").modulate
	SelectedAnimation.get_node("Light2D").visible = true
	SelectedAnimation.get_node("Sprite").visible = true

func update_keys():
	
	#$CollisionShape2D2.disabled = false
	#$CollisionShape2D3.disabled = false
	"""keys.clear()
	reverse_keys.clear()
	if MainScene.Keys.keys().has(Vector2(location.x + 0.5, location.y)):
		var key = MainScene.Keys[Vector2(location.x + 0.5, location.y)]
		keys[key] = 0
		reverse_keys[0] = key
	if MainScene.Keys.keys().has(Vector2(location.x - 0.5, location.y)):
		var key = MainScene.Keys[Vector2(location.x - 0.5, location.y)]
		keys[key] = 2
		reverse_keys[2] = key
	if MainScene.Keys.keys().has(Vector2(location.x, location.y + 0.5)):
		var key = MainScene.Keys[Vector2(location.x, location.y + 0.5)]
		keys[key] = 1
		reverse_keys[1] = key
	if MainScene.Keys.keys().has(Vector2(location.x, location.y - 0.5)):
		var key = MainScene.Keys[Vector2(location.x, location.y - 0.5)]
		keys[key] = 3
		reverse_keys[3] = key"""
	
	if keys.size() > 0:
		for i in keys:
			if is_instance_valid(i):
				if !i.is_connected("send_value", self, "_on_keys_send_value"):
					i.connect("send_value", self, "_on_keys_send_value")
			else:
				keys.erase(i)
	
	#update_neighbor_nodes()

func update_neighbor_nodes():
	#print("我是", self)
	#print("与我连接的键是", keys)
	neighbor_nodes = {}
	for i in keys:
		#print("键" + str(i) + "连接的节点是" + str(i.nodes.keys()))
		var _arr = i.nodes.keys()
		_arr.erase(self)
		#print("除去自己，连接的节点是", _arr)
		if _arr.size() > 0:
			if is_instance_valid(_arr[0]):
				neighbor_nodes[_arr[0]] = i
	#print("我的邻节点是", neighbor_nodes)
	#print("_____")
	
	#for i in neighbor_nodes:
		#i.update_neighbor_nodes()
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

func set_position_with_location(location):
	global_position = location * (Global.NODE_RADIUS * 2 + Global.KEY_LENGTH)

func _on_SE_EGY_arrived():
	var _modulate = modulate
	Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.6, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#Tween1.interpolate_property($Light2D, "color", $Light2D.color, Color(0.17, 0.71, 0.95, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#Tween1.interpolate_property($Light2D, "color", $Light2D.color, modulate, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	pass

func _on_SE_ENT_arrived():
	var _modulate = modulate
	Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.6, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#Tween1.interpolate_property($Light2D, "color", $Light2D.color, Color(0.05, 0.05, 0.05, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#Tween1.interpolate_property($Light2D, "color", $Light2D.color, modulate, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	pass

func _on_SE_ORD_arrived():
	var _modulate = modulate
	Tween1.stop_all()
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.6, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#Tween1.interpolate_property($Light2D, "color", $Light2D.color, Color(0.61, 1, 0.39, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#Tween1.interpolate_property($Light2D, "color", $Light2D.color, modulate, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
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
