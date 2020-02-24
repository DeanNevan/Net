extends Node2D

signal _all_done

signal Nodes_work
signal Keys_work

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

var wait_time = 1
var is_init_done = false

var _load_data_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	print("主场景开始")
	$Camera2D.zoom = Vector2(0.15, 0.15)
	randomize()
	connect("_all_done", self, "_on_all_done")
	$Camera2D.current = true
	$Camera2D.position = Vector2()
	generate_world()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_init_done:
		return
	match who_work:
		NODES_WORK:
			if done_Nodes_count == Nodes_count:
				done_Nodes_count = 0
				emit_signal("_all_done")
		KEYS_WORK:
			if done_Keys_count == Keys_count:
				done_Keys_count = 0
				emit_signal("_all_done")
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
		yield(get_tree(), "idle_frame")
		$Nodes/EmptyNodes.get_child(randi() % $Nodes/EmptyNodes.get_child_count()).entropy_value = ceil(rand_range(1, Global.GENERATE_ENTROPY_DEGREE * 9))
	
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "更新节点信息..."
	yield(get_tree(), "idle_frame")
	$LoadData/ProgressBar.max_value = Keys_count
	$LoadData/ProgressBar.value = 0
	update_all_Nodes_connect()
	
	
	$LoadData/ProgressBar.value = $LoadData/ProgressBar.max_value
	$LoadData/Label.text += "完成" + "\n" + "游戏初始化...完成"
	yield(get_tree(), "idle_frame")
	
	
	#$LoadData/Label.visible = false
	#$LoadData/ProgressBar.visible = false
	is_init_done = true
	pass

func _on_all_done():
	yield(get_tree().create_timer(wait_time), "timeout")
	match who_work:
		NODES_WORK:
			_to_next_stage(KEYS_WORK)
		KEYS_WORK:
			_to_next_stage(NODES_WORK)

func _to_next_stage(stage):
	who_work = stage
	match who_work:
		NODES_WORK:
			emit_signal("Nodes_work")
		KEYS_WORK:
			emit_signal("Keys_work")
	pass

func _on_Node_done():
	done_Nodes_count += 1
	pass

func _on_Key_done():
	done_Keys_count += 1
	pass

func update_all_Nodes_connect():
	for i in $Nodes/EmptyNodes.get_child_count():
		if is_instance_valid($Nodes/EmptyNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Nodes/EmptyNodes.get_child(i).is_connected("done", self, "_on_Node_done") and !get_child(i).is_queued_for_deletion():
				$Nodes/EmptyNodes.get_child(i).connect("done", self, "_on_Node_done")
			yield(get_tree(), "idle_frame")
			$Nodes/EmptyNodes.get_child(i).update_keys()
			$Nodes/EmptyNodes.get_child(i).update_neighbor_nodes()
	for i in $Nodes/EntropyNodes.get_child_count():
		if is_instance_valid($Nodes/EntropyNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Nodes/EntropyNodes.get_child(i).is_connected("done", self, "_on_Node_done") and !get_child(i).is_queued_for_deletion():
				$Nodes/EntropyNodes.get_child(i).connect("done", self, "_on_Node_done")
			yield(get_tree(), "idle_frame")
			$Nodes/EntropyNodes.get_child(i).update_keys()
			$Nodes/EntropyNodes.get_child(i).update_neighbor_nodes()
	for i in $Nodes/OrderNodes.get_child_count():
		if is_instance_valid($Nodes/OrderNodes.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Nodes/OrderNodes.get_child(i).is_connected("done", self, "_on_Node_done") and !get_child(i).is_queued_for_deletion():
				$Nodes/OrderNodes.get_child(i).connect("done", self, "_on_Node_done")
			yield(get_tree(), "idle_frame")
			$Nodes/OrderNodes.get_child(i).update_keys()
			$Nodes/OrderNodes.get_child(i).update_neighbor_nodes()

func update_all_Keys_connect():
	for i in $Keys.get_child_count():
		if is_instance_valid($Keys.get_child(i)):
			$LoadData/ProgressBar.value += 1
			if !$Keys.get_child(i).is_connected("done", self, "_on_Key_done") and !get_child(i).is_queued_for_deletion():
				$Keys.get_child(i).connect("done", self, "_on_Key_done")
			yield(get_tree(), "idle_frame")
			$Keys.get_child(i).update_nodes()

func _on_EmptyNode_turned_to_EntropyNode(origin_Node):
	var new_EntropyNode = Global.ENTROPY_NODE.instance()
	new_EntropyNode.location = origin_Node.location
	new_EntropyNode.MainScene = self
	$Nodes/EntropyNodes.add_child(new_EntropyNode)
	new_EntropyNode.connect("done", self, "_on_Node_done")
	new_EntropyNode.connect("destroyed", self, "_on_EntropyNode_destroyed")
	Nodes[origin_Node.location] = new_EntropyNode
	#yield(get_tree(), "idle_frame")
	new_EntropyNode.update_keys()
	new_EntropyNode.update_neighbor_nodes()
	origin_Node.queue_free()
	pass

func _on_EntropyNode_destroyed(origin_Node, accepted_ORD):
	var new_EmptyNode = Global.EMPTY_NODE.instance()
	new_EmptyNode.location = origin_Node.location
	new_EmptyNode.MainScene = self
	new_EmptyNode.entropy_value = 9 - accepted_ORD
	$Nodes/EmptyNodes.add_child(new_EmptyNode)
	new_EmptyNode.connect("done", self, "_on_Node_done")
	new_EmptyNode.connect("turned", self, "_on_EmptyNode_turned_to_EntropyNode")
	Nodes[origin_Node.location] = new_EmptyNode
	new_EmptyNode.update_keys()
	new_EmptyNode.update_neighbor_nodes()
	origin_Node.queue_free()
	pass

func _on_OrderNode_destroyed(origin_Node, accepted_ENT):
	var new_EmptyNode = Global.EMPTY_NODE.instance()
	new_EmptyNode.location = origin_Node.location
	new_EmptyNode.MainScene = self
	new_EmptyNode.entropy_value = 0 + accepted_ENT
	$Nodes/EmptyNodes.add_child(new_EmptyNode)
	new_EmptyNode.connect("done", self, "_on_Node_done")
	new_EmptyNode.connect("turned", self, "_on_EmptyNode_turned_to_EntropyNode")
	Nodes[origin_Node.location] = new_EmptyNode
	new_EmptyNode.update_keys()
	new_EmptyNode.update_neighbor_nodes()
	origin_Node.queue_free()
	pass

func _on_built_OrderNode(origin_Node):
	pass
