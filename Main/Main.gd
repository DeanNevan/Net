extends Node2D

signal _all_done

signal Nodes_work
signal Keys_work

signal time_speed_changed(origin_speed, target_speed)
signal pause_game
signal resume_game

enum {
	KEYS_WORK
	NODES_WORK
}

var GENERATE_NODES_COUNT = 0#生成的节点数量
var GENERATE_RANDOM_DEGREE = 0#生成的节点混乱程度
var GENERATE_KEYS_DENSITY = 0#生成的键密度
var GENERATE_ENTRY_DEGREE = 0#生成的熵程度

var Nodes = {}

var Nodes_count = 0
var Keys_count = 0

var done_Nodes_count = 0
var done_Keys_count = 0
var who_work = NODES_WORK

var wait_time = 0.4
var is_init_done = false
var is_game_started = false
var is_game_paused = false

var is_double_selected = false
var double_select_Node_or_Key

var control_time_speed = 1

var round_number := 0

var _load_data_count = 0

var TweenStartGame = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenStartGame)
	#$WorldEnvironment.environment.adjustment_brightness = 0.01
	TweenStartGame.interpolate_property($WorldEnvironment.environment, "adjustment_brightness", 1, 0.01, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenStartGame.start()
	yield(TweenStartGame, "tween_completed")
	TweenStartGame.interpolate_property($WorldEnvironment.environment, "adjustment_brightness", 0.01, 1, 2.5, Tween.TRANS_SINE, Tween.EASE_IN)
	TweenStartGame.start()
	print("主场景开始")
	$Camera2D.zoom = Vector2(0.15, 0.15)
	$GUI/TimeSpeedBar.max_value = Global.MAX_TIME_SPEED
	$GUI/TimeSpeedBar.value = 1
	Engine.time_scale = Global.time_speed
	randomize()
	connect("time_speed_changed", self, "_on_time_speed_changed")
	connect("pause_game", self, "_on_paused_game")
	connect("resume_game", self, "_on_resumed_game")
	connect("_all_done", self, "_on_all_done")
	
	connect("Keys_work", self, "_on_Keys_work")
	connect("Nodes_work", self, "_on_Nodes_work")
	
	$GUI/BuildMenu.connect("build_Node", self, "_on_build_Node")
	
	$Camera2D.current = true
	$Camera2D.position = Vector2()
	generate_world()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_init_done:
		return
	elif !is_game_started:
		emit_signal("Nodes_work")
		is_game_started = true
	if Input.is_action_just_pressed("key_space"):
		if Global.time_speed != 0:
			emit_signal("pause_game")
		else:
			emit_signal("resume_game")
	if Input.is_key_pressed(KEY_EQUAL):
		control_time_speed += 0.1
		control_time_speed = clamp(control_time_speed, Global.MIN_TIME_SPEED, Global.MAX_TIME_SPEED)
		emit_signal("time_speed_changed", Global.time_speed, control_time_speed)
	if Input.is_key_pressed(KEY_MINUS):
		control_time_speed = clamp(control_time_speed - 0.1, Global.MIN_TIME_SPEED, Global.MAX_TIME_SPEED)
		emit_signal("time_speed_changed", Global.time_speed, control_time_speed)
	match who_work:
		NODES_WORK:
			if done_Nodes_count >= Nodes_count:
				done_Nodes_count = 0
				emit_signal("_all_done")
		KEYS_WORK:
			if done_Keys_count >= Keys_count:
				done_Keys_count = 0
				emit_signal("_all_done")
	$DebugData/Label.text = "回合数：" + str(round_number) + "\n" + "运行中：" + str(who_work) + "\n"
	$DebugData/Label.text += "运行完成节点数：" + str(done_Nodes_count) + "/" + str(Nodes_count) + "\n"
	$DebugData/Label.text += "运行完成键数：" + str(done_Keys_count) + "/" + str(Keys_count) + "\n"
	if is_double_selected:
		$DebugData/Label.text += "选中的是" + double_select_Node_or_Key.name_CN
		if double_select_Node_or_Key.type == Global.NODE_TYPE.EMP_NODE:
			 $DebugData/Label.text += "熵值：" + str(double_select_Node_or_Key.entropy_value)
	
	#print("ggg", Global.time_speed)
	#print("ccc", control_time_speed)
	#print("eee", Engine.time_scale)
	pass

func _on_time_speed_changed(origin_speed, target_speed):
	if !is_game_paused:
		$GUI/TimeSpeedBar.change_value(target_speed)
		Global.time_speed = target_speed
		Engine.time_scale = target_speed
	pass

func _on_paused_game():
	is_game_paused = true
	Global.time_speed = 0
	$GUI/TimeSpeedBar.change_value(0)
	#Engine.time_scale = Global.time_speed
	pass

func _on_resumed_game():
	is_game_paused = false
	Global.time_speed = control_time_speed
	$GUI/TimeSpeedBar.change_value(control_time_speed)
	#Engine.time_scale = Global.time_speed
	pass

func _on_all_done():
	yield(get_tree().create_timer(wait_time), "timeout")
	match who_work:
		NODES_WORK:
			_to_next_stage(KEYS_WORK)
		KEYS_WORK:
			_to_next_stage(NODES_WORK)

func _to_next_stage(stage):
	round_number += 1
	who_work = stage
	match who_work:
		NODES_WORK:
			emit_signal("Nodes_work")
		KEYS_WORK:
			emit_signal("Keys_work")
	pass

func _on_Keys_work():
	for i in $Keys.get_child_count():
		$Keys.get_child(i).work()
		if Global.time_speed == 0:
			yield(self, "resume_game")
		elif i % int(ceil(3 * Global.time_speed)) == 0:
			yield(get_tree(), "idle_frame")
	pass

func _on_Nodes_work():
	var _count = $Nodes/EmptyNodes.get_child_count()
	for i in _count:
		if i >= $Nodes/EmptyNodes.get_child_count():
			break
		if is_instance_valid($Nodes/EmptyNodes.get_child(i)) and $Nodes/EmptyNodes.get_child(i) != null:
			$Nodes/EmptyNodes.get_child(i).work()
		if Global.time_speed == 0:
			yield(self, "resume_game")
		elif i % int(ceil(3 * Global.time_speed)) == 0:
			yield(get_tree(), "idle_frame")
	_count = $Nodes/EntropyNodes.get_child_count()
	for i in _count:
		if i >= $Nodes/EntropyNodes.get_child_count():
			break
		if is_instance_valid($Nodes/EntropyNodes.get_child(i)) and $Nodes/EntropyNodes.get_child(i) != null:
			$Nodes/EntropyNodes.get_child(i).work()
		if Global.time_speed == 0:
			yield(self, "resume_game")
		elif i % int(ceil(3 * Global.time_speed)) == 0:
			yield(get_tree(), "idle_frame")
	_count = $Nodes/OrderNodes.get_child_count()
	for i in _count:
		if i >= $Nodes/OrderNodes.get_child_count():
			break
		if is_instance_valid($Nodes/OrderNodes.get_child(i)) and $Nodes/OrderNodes.get_child(i) != null:
			$Nodes/OrderNodes.get_child(i).work()
		if Global.time_speed == 0:
			yield(self, "resume_game")
		elif i % int(ceil(3 * Global.time_speed)) == 0:
			yield(get_tree(), "idle_frame")
		
	pass

func _on_Node_done():
	done_Nodes_count += 1
	pass

func _on_Key_done():
	done_Keys_count += 1
	pass

func generate_world():
	$LoadData/Label.visible = true
	$LoadData/ProgressBar.visible = true
	$LoadData/Label.text = "生成空节点..."
	_load_data_count = 0
	$LoadData/ProgressBar.max_value = Global.Nodes_locations.size()
	for i in Global.Nodes_locations:
		Nodes_count += 1
		_load_data_count += 1
		$LoadData/ProgressBar.value = _load_data_count
		if _load_data_count % 4 == 0:
			yield(get_tree(), "idle_frame")
		var new_EmptyNode = Global.EMPTY_NODE.instance()
		new_EmptyNode.location = i
		new_EmptyNode.MainScene = self
		$Nodes/EmptyNodes.add_child(new_EmptyNode)
		new_EmptyNode.connect("done", self, "_on_Node_done")
		new_EmptyNode.connect("turned", self, "_on_EmptyNode_turned_to_EntropyNode")
		new_EmptyNode.connect("double_selected", self, "_on_Node_double_selected")
		new_EmptyNode.connect("cancel_double_select", self, "_on_Node_cancel_double_select")
		Nodes[i] = new_EmptyNode
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "连接键与节点..."
	_load_data_count = 0
	$LoadData/ProgressBar.max_value = Global.Keys_locations.size()
	for i in Global.Keys_locations.keys():
		Keys_count += 1
		_load_data_count += 1
		$LoadData/ProgressBar.value = _load_data_count
		if _load_data_count % 4 == 0:
			yield(get_tree(), "idle_frame")
		var new_Key = Global.KEY.instance()
		new_Key.location = i
		new_Key.direction = Global.Keys_locations[i]
		new_Key.MainScene = self
		$Keys.add_child(new_Key)
		new_Key.connect("done", self, "_on_Key_done")
		new_Key.connect("double_selected", self, "_on_Key_double_selected")
		new_Key.connect("cancel_double_select", self, "_on_Key_cancel_double_select")
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "将空节点替换成熵节点..."
	yield(get_tree(), "idle_frame")
	$LoadData/ProgressBar.value = 0
	var _ran = rand_range(Nodes_count / 20, Nodes_count / 10) * Global.GENERATE_ENTROPY_DEGREE
	_ran = ceil(_ran)
	var _arr = [Global.Nodes_locations[randi() % Global.Nodes_locations.size()]]
	$LoadData/ProgressBar.max_value = _ran * 2
	for i in _ran - 1:
		$LoadData/ProgressBar.value += 1
		while true:
			var _new = _arr[randi() % _arr.size()]
			var _nei = [Vector2(_new.x + 1, _new.y),
						Vector2(_new.x - 1, _new.y),
						Vector2(_new.x, _new.y + 1),
						Vector2(_new.x, _new.y - 1)]
			for n in _nei:
				if !_arr.has(n) and Global.Nodes_locations.has(n):
					_arr.append(n)
			if _arr.size() >= _ran:
				break
		if _arr.size() >= _ran:
			break
	_arr.resize(_ran)
	for i in _arr:
		$LoadData/ProgressBar.value += 1
		var _empty_Node = Nodes[i]
		_empty_Node.turn_to_EntropyNode()
		yield(get_tree(), "idle_frame")
		pass
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "更新键信息..."
	yield(get_tree(), "idle_frame")
	$LoadData/ProgressBar.max_value = Nodes_count
	$LoadData/ProgressBar.value = 0
	update_all_Keys_connect()
	
	
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "添加熵到空节点..."
	yield(get_tree(), "idle_frame")
	_ran = rand_range(Nodes_count / 8, Nodes_count / 5) * Global.GENERATE_ENTROPY_DEGREE
	_ran = ceil(_ran)
	_arr.clear()
	_arr = []
	$LoadData/ProgressBar.max_value = _ran
	for i in _ran:
		$LoadData/ProgressBar.value += 1
		if i % 2 == 0:
			yield(get_tree(), "idle_frame")
		$Nodes/EmptyNodes.get_child(randi() % $Nodes/EmptyNodes.get_child_count()).entropy_value = ceil(rand_range(1, Global.GENERATE_ENTROPY_DEGREE * 9))
	
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "更新节点信息..."
	yield(get_tree(), "idle_frame")
	
	$LoadData/ProgressBar.max_value = Keys_count
	$LoadData/ProgressBar.value = 0
	update_all_Nodes_connect()
	
	
	
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "更新灯光系统..."
	yield(get_tree(), "idle_frame")
	$LoadData/ProgressBar.max_value = Nodes_count
	$LoadData/ProgressBar.value = 0
	for i in $Nodes/EmptyNodes.get_child_count():
		if is_instance_valid($Nodes/EmptyNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			$Nodes/EmptyNodes.get_child(i).turn_off_lights()
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
	for i in $Nodes/EntropyNodes.get_child_count():
		if is_instance_valid($Nodes/EntropyNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			$Nodes/EntropyNodes.get_child(i).turn_off_lights()
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
	for i in $Nodes/OrderNodes.get_child_count():
		if is_instance_valid($Nodes/OrderNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			$Nodes/OrderNodes.get_child(i).turn_off_lights()
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
	
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "游戏初始化..."
	yield(get_tree(), "idle_frame")
	
	for i in $Keys.get_child_count():
		if is_instance_valid($Keys.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
			$Keys.get_child(i).update_nodes()
	
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成"
	yield(get_tree(), "idle_frame")
	$LoadData/Label.visible = false
	$LoadData/ProgressBar.visible = false
	is_init_done = true
	pass

func update_all_Nodes_connect():
	for i in $Nodes/EmptyNodes.get_child_count():
		if is_instance_valid($Nodes/EmptyNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Nodes/EmptyNodes.get_child(i).is_connected("done", self, "_on_Node_done") and !get_child(i).is_queued_for_deletion():
				$Nodes/EmptyNodes.get_child(i).connect("done", self, "_on_Node_done")
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
			$Nodes/EmptyNodes.get_child(i).update_keys()
			$Nodes/EmptyNodes.get_child(i).update_neighbor_nodes()
	for i in $Nodes/EntropyNodes.get_child_count():
		if is_instance_valid($Nodes/EntropyNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Nodes/EntropyNodes.get_child(i).is_connected("done", self, "_on_Node_done") and !get_child(i).is_queued_for_deletion():
				$Nodes/EntropyNodes.get_child(i).connect("done", self, "_on_Node_done")
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
			$Nodes/EntropyNodes.get_child(i).update_keys()
			$Nodes/EntropyNodes.get_child(i).update_neighbor_nodes()
	for i in $Nodes/OrderNodes.get_child_count():
		if is_instance_valid($Nodes/OrderNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Nodes/OrderNodes.get_child(i).is_connected("done", self, "_on_Node_done") and !get_child(i).is_queued_for_deletion():
				$Nodes/OrderNodes.get_child(i).connect("done", self, "_on_Node_done")
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
			$Nodes/OrderNodes.get_child(i).update_keys()
			$Nodes/OrderNodes.get_child(i).update_neighbor_nodes()

func update_all_Keys_connect():
	for i in $Keys.get_child_count():
		if is_instance_valid($Keys.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Keys.get_child(i).is_connected("done", self, "_on_Key_done") and !get_child(i).is_queued_for_deletion():
				$Keys.get_child(i).connect("done", self, "_on_Key_done")
			if i % 4 == 0:
				yield(get_tree(), "idle_frame")
			$Keys.get_child(i).update_nodes()

func _on_Node_double_selected(node):
	is_double_selected = true
	double_select_Node_or_Key = node
	$Camera2D.position = node.position
	$Camera2D.smooth_zoom(Vector2(2.5, 2.5),0.5)
	pass

func _on_Node_cancel_double_select(node):
	is_double_selected = false
	double_select_Node_or_Key = null
	$Camera2D.smooth_zoom(Vector2(5, 5), 0.5)
	pass

func _on_Key_double_selected(key):
	is_double_selected = true
	double_select_Node_or_Key = key
	$Camera2D.position = key.position
	$Camera2D.smooth_zoom(Vector2(2.5, 2.5), 0.5)
	pass

func _on_Key_cancel_double_select(key):
	is_double_selected = false
	double_select_Node_or_Key = null
	$Camera2D.smooth_zoom(Vector2(5, 5), 0.5)
	pass

func _on_EmptyNode_turned_to_EntropyNode(origin_Node):
	var new_EntropyNode = Global.ENTROPY_NODE.instance()
	new_EntropyNode.location = origin_Node.location
	new_EntropyNode.MainScene = self
	$Nodes/EntropyNodes.add_child(new_EntropyNode)
	new_EntropyNode.connect("done", self, "_on_Node_done")
	new_EntropyNode.connect("destroyed", self, "_on_EntropyNode_destroyed")
	new_EntropyNode.connect("double_selected", self, "_on_Node_double_selected")
	new_EntropyNode.connect("cancel_double_select", self, "_on_Node_cancel_double_select")
	Nodes[origin_Node.location] = new_EntropyNode
	#yield(get_tree(), "idle_frame")
	new_EntropyNode.update_keys()
	new_EntropyNode.update_neighbor_nodes()
	new_EntropyNode.accepted_value = origin_Node.accepted_value
	origin_Node.queue_free()
	if is_game_started and who_work == NODES_WORK:
		yield(get_tree(), "idle_frame")
		new_EntropyNode.work()
	
	pass

func _on_EntropyNode_destroyed(origin_Node, accepted_ORD):
	var new_EmptyNode = Global.EMPTY_NODE.instance()
	new_EmptyNode.location = origin_Node.location
	new_EmptyNode.MainScene = self
	new_EmptyNode.entropy_value = 9 - accepted_ORD
	$Nodes/EmptyNodes.add_child(new_EmptyNode)
	new_EmptyNode.connect("done", self, "_on_Node_done")
	new_EmptyNode.connect("turned", self, "_on_EmptyNode_turned_to_EntropyNode")
	new_EmptyNode.connect("double_selected", self, "_on_Node_double_selected")
	new_EmptyNode.connect("cancel_double_select", self, "_on_Node_cancel_double_select")
	Nodes[origin_Node.location] = new_EmptyNode
	new_EmptyNode.update_keys()
	new_EmptyNode.update_neighbor_nodes()
	new_EmptyNode.accepted_value = origin_Node.accepted_value
	origin_Node.queue_free()
	if is_game_started and who_work == NODES_WORK:
		yield(get_tree(), "idle_frame")
		new_EmptyNode.work()
	
	pass

func _on_OrderNode_destroyed(origin_Node, accepted_ENT):
	var new_EmptyNode = Global.EMPTY_NODE.instance()
	new_EmptyNode.location = origin_Node.location
	new_EmptyNode.MainScene = self
	new_EmptyNode.entropy_value = 0 + accepted_ENT
	$Nodes/EmptyNodes.add_child(new_EmptyNode)
	new_EmptyNode.connect("done", self, "_on_Node_done")
	new_EmptyNode.connect("turned", self, "_on_EmptyNode_turned_to_EntropyNode")
	new_EmptyNode.connect("double_selected", self, "_on_Node_double_selected")
	new_EmptyNode.connect("cancel_double_select", self, "_on_Node_cancel_double_select")
	Nodes[origin_Node.location] = new_EmptyNode
	new_EmptyNode.update_keys()
	new_EmptyNode.update_neighbor_nodes()
	new_EmptyNode.accepted_value = origin_Node.accepted_value
	origin_Node.queue_free()
	if is_game_started and who_work == NODES_WORK:
		yield(get_tree(), "idle_frame")
		new_EmptyNode.work()
	
	pass

func _on_build_Node(target_Node):
	if double_select_Node_or_Key == null:
		return
	if double_select_Node_or_Key.type == Global.NODE_TYPE.EMP_NODE:
		if double_select_Node_or_Key.entropy_value != 0:
			return
	var new_Node = target_Node.instance()
	new_Node.location = double_select_Node_or_Key.location
	new_Node.MainScene = self
	$Nodes/OrderNodes.add_child(new_Node)
	new_Node.connect("done", self, "_on_Node_done")
	new_Node.connect("destroyed", self, "_on_OrderNode_destroyed")
	new_Node.connect("double_selected", self, "_on_Node_double_selected")
	new_Node.connect("cancel_double_select", self, "_on_Node_cancel_double_select")
	Nodes[double_select_Node_or_Key.location] = new_Node
	new_Node.update_keys()
	new_Node.update_neighbor_nodes()
	new_Node.accepted_value = double_select_Node_or_Key.accepted_value
	double_select_Node_or_Key.queue_free()
	if is_game_started and who_work == NODES_WORK:
		yield(get_tree(), "idle_frame")
		new_Node.work()
	pass
