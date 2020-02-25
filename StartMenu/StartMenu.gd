extends Control

signal generate_done

var is_generated_done = false

var enable_camera = false

var _load_data_count = 0

onready var KeysArray = [$NormalKey1, $NormalKey2, $NormalKey3, $NormalKey4, $NormalKeyEnd]

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for i in KeysArray:
		i.get_node("CollisionShape2D").disabled = true
	
	add_child(Tween1)
	$StartArrow.connect("start", self, "generate_world")
	connect("generate_done", self, "change_to_MainScene")
	$RandomStartButton.connect("pressed", self, "_on_RandomStartButton_pressed")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enable_camera:
		$StartArrow.is_ok()
		$Camera2D.current = true
		$Camera2D.position = $StartArrow.rect_position
		Tween1.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(0.15, 0.15), 4.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if !Tween1.is_active():
			Tween1.start()
		#yield(get_tree(), "idle_frame")
	if is_generated_done:
		emit_signal("generate_done")
	pass

func _on_RandomStartButton_pressed():
	for i in get_child_count():
		if get_child(i).has_method("update_text"):
			get_child(i).set_value(rand_range(get_child(i).min_value, get_child(i).max_value))
	pass

#特效
func generate_SE_values(target):
	var new_SE_Values = Global.SE_EGY.instance()
	new_SE_Values.direction = -1
	new_SE_Values.direction_vector = Vector2(1, 0)
	new_SE_Values.type = Global.VALUE_TYPE.BLANK
	target.add_child(new_SE_Values)
	new_SE_Values.start()

func change_to_MainScene():
	disconnect("generate_done", self, "change_to_MainScene")
	yield($StartArrow, "done")
	var MainScene = load("res://Main/Main.tscn")
	print("start")
	get_tree().change_scene_to(MainScene)
	pass

func generate_world():
	print("开始生成节点位置信息")
	$LoadData/ProgressBar.visible = true
	$LoadData/Label.visible = true
	$LoadData/Label.text = "生成节点位置信息..."
	var Nodes_count = $GenerateNodesCount.value
	var random_degree = $GenerateRandomDegree.value / 100
	var key_density = $GenerateKeysDensity.value / 100
	Global.GENERATE_NODES_COUNT = Nodes_count
	Global.GENERATE_RANDOM_DEGREE = random_degree
	Global.GENERATE_KEYS_DENSITY = key_density
	Global.GENERATE_ENTROPY_DEGREE = $GenerateEntryDegree.value / 100
	
	$LoadData/ProgressBar.max_value = (Nodes_count)
	var _locations = [Vector2(0, 0)]
	_load_data_count = 0
	for i in Nodes_count:
		_load_data_count += 1
		$LoadData/ProgressBar.value = _load_data_count
		if _load_data_count % 4 == 0:
			yield(get_tree(), "idle_frame")
		#print("---开始找点---")
		var new_location_found = false
		_locations.shuffle()
		for loc in _locations:
			#print("循环开始,_locations:",_locations)
			#print("抽取目标点：", loc)
			var neighbors_count = 0
			var empty_locations = []
			if _locations.has(Vector2(loc.x + 1, loc.y)):
				neighbors_count += 1
			else:
				empty_locations.append(Vector2(loc.x + 1, loc.y))
			if _locations.has(Vector2(loc.x - 1, loc.y)):
				neighbors_count += 1
			else:
				empty_locations.append(Vector2(loc.x - 1, loc.y))
			if _locations.has(Vector2(loc.x, loc.y + 1)):
				neighbors_count += 1
			else:
				empty_locations.append(Vector2(loc.x, loc.y + 1))
			if _locations.has(Vector2(loc.x, loc.y - 1)):
				neighbors_count += 1
			else:
				empty_locations.append(Vector2(loc.x, loc.y - 1))
			#print("该点有" + str(empty_locations.size()) + "个空相邻点")
			#print("分别是：", empty_locations)
			#print("判定")
			if neighbors_count == 4:
				#print("_locations:",_locations)
				#print("无空相邻点，不生成！")
				continue
			elif neighbors_count == 3:
				if randf() < $GenerateRandomDegree.value / 100:
					#print("_locations:",_locations)
					#print("不生成！")
					continue
			elif neighbors_count == 2:
				var _ran = clamp(abs(($GenerateRandomDegree.value / 100) - 0.5) * 2, 0.01, 1)
				if randf() > _ran:
					#print("_locations:",_locations)
					#print("不生成！")
					continue
			elif neighbors_count == 1:
				if randf() > $GenerateRandomDegree.value / 100:
					#print("_locations:",_locations)
					#print("不生成！")
					continue
			#print("生成！")
			var target_loc = empty_locations[randi() % empty_locations.size()]
			#print("新的点是", target_loc)
			new_location_found = true
			_locations.append(target_loc)
			break
		if !new_location_found:
			#print("没找到")
			i += 1
		#print("---结束找点---")
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	Global.Nodes_locations = _locations.duplicate()
	print("生成节点位置信息完成")
	print(Global.Nodes_locations.size())
	$LoadData/Label.text += "完成" + "\n" + "生成键位置信息..."
	
	var _Keys_locations = {}
	
	
	var _lonely_Nodes = _locations.duplicate()
	_lonely_Nodes.erase(Vector2(0, 0))
	
	var _size = _lonely_Nodes.size()
	while true:
		_load_data_count = 0
		for i in _lonely_Nodes:
			_load_data_count += 1
			$LoadData/ProgressBar.value = _load_data_count
			$LoadData/ProgressBar.max_value = _lonely_Nodes.size()
			if _load_data_count % 4 == 0:
				yield(get_tree(), "idle_frame")
			#if _load_data_count == 1:
				#i = Vector2()
			var neighbor_Keys_locations = []
			var neighbor_Nodes_locations = [Vector2(i.x + 1, i.y),
											Vector2(i.x - 1, i.y),
											Vector2(i.x, i.y + 1),
											Vector2(i.x, i.y - 1)]
			for n in neighbor_Nodes_locations:
				if _locations.has(n):
					neighbor_Keys_locations.append((n + i) / 2)
			var empty_neighbor_Keys_locations = []
			for n in neighbor_Keys_locations:
				if !_Keys_locations.keys().has(n):
					empty_neighbor_Keys_locations.append(n)
			var _new = []
			#if i == Vector2():
				#if neighbor_Keys_locations.size() != 0:
					#_new.append(neighbor_Keys_locations[randi() % neighbor_Keys_locations.size()])
			if empty_neighbor_Keys_locations.size() == 0:
				pass
			else:
				while true:
					if empty_neighbor_Keys_locations.size() == 4:
						pass
					elif empty_neighbor_Keys_locations.size() == 0:
						break
					elif randf() > key_density:
						break
					var _ran = empty_neighbor_Keys_locations[randi() % empty_neighbor_Keys_locations.size()]
					_new.append(_ran)
					empty_neighbor_Keys_locations.erase(_ran)
				#print(_new)
				for n in _new:
					if n.x > i.x + 0.1:
						_Keys_locations[n] = 0
					elif n.x < i.x - 0.1:
						_Keys_locations[n] = 2
					elif n.y > i.y + 0.1:
						_Keys_locations[n] = 1
					else:
						_Keys_locations[n] = 3
			
			
			var _arr_all = [i]
			var _arr = [i]
			var good_connect = false
			while true:
				for a in _arr:
					if _arr.size() == 0:
						break
					if _Keys_locations.has(Vector2(a.x + 0.5, a.y)) and !_arr_all.has(Vector2(a.x + 1, a.y)):
						var _l = Vector2(a.x + 1, a.y)
						_arr_all.append(_l)
						_arr.append(_l)
					if _Keys_locations.has(Vector2(a.x - 0.5, a.y)) and !_arr_all.has(Vector2(a.x - 1, a.y)):
						var _l = Vector2(a.x - 1, a.y)
						_arr_all.append(_l)
						_arr.append(_l)
					if _Keys_locations.has(Vector2(a.x, a.y + 0.5)) and !_arr_all.has(Vector2(a.x, a.y + 1)):
						var _l = Vector2(a.x, a.y + 1)
						_arr_all.append(_l)
						_arr.append(_l)
					if _Keys_locations.has(Vector2(a.x, a.y - 0.5)) and !_arr_all.has(Vector2(a.x, a.y - 1)):
						var _l = Vector2(a.x, a.y - 1)
						_arr_all.append(_l)
						_arr.append(_l)
					_arr.erase(a)
					
				if _arr.size() == 0:
					break
			for a in _arr_all:
				if !_lonely_Nodes.has(a):
					good_connect = true
					break
			if good_connect:
				for a in _arr_all:
					_lonely_Nodes.erase(a)
			if !good_connect or _lonely_Nodes.size() == 1:
				if empty_neighbor_Keys_locations.size() > 0:
					var _n = empty_neighbor_Keys_locations[randi() % empty_neighbor_Keys_locations.size()]
					if _n.x > i.x + 0.1:
						_Keys_locations[_n] = 0
					elif _n.x < i.x - 0.1:
						_Keys_locations[_n] = 2
					elif _n.y > i.y + 0.1:
						_Keys_locations[_n] = 1
					else:
						_Keys_locations[_n] = 3
			if _lonely_Nodes.size() == 1:
				break
		if _lonely_Nodes.size() == _size:
			break
		_size = _lonely_Nodes.size()
		if _lonely_Nodes.size() == 1:
			break
	
	Global.Keys_locations = _Keys_locations.duplicate()
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "转到主场景"
	emit_signal("generate_done")
	is_generated_done = true
	pass
