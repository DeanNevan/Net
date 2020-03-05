extends Node

signal custom_generate_done

#ENT——熵值
#ORD——秩序值
#SENT——超熵值
#EGY——能量值
enum VALUE_TYPE{
	EGY
	ENT
	ORD
	BLANK
}

enum NODE_TYPE{
	ENT_NODE#熵节点
	ORD_NODE#秩序节点
	EMP_NODE#非秩序节点
}

enum KEY_TYPE{
	KEY
}

var NODE_RADIUS = 199.5
var KEY_LENGTH = 330

var MAX_NODES_COUNT = 400

var MAX_ENT = 10
var MAX_ORD = 10
var MAX_SENT = 10

var EMPTY_NODE = preload("res://Nodes/EmptyNode/EmptyNode.tscn")
var ENTROPY_NODE = preload("res://Nodes/EntropyNode/EntropyNode.tscn")
var KEY = preload("res://Keys/NormalKey.tscn")

var SE_ENT = preload("res://Assets/SE/SE_Values/1/SE_Values_1.tscn")
var SE_ORD = preload("res://Assets/SE/SE_Values/1/SE_Values_1.tscn")
var SE_EGY = preload("res://Assets/SE/SE_Values/1/SE_Values_1.tscn")
var SE_MainMenu_value = preload("res://Assets/SE/SE_Values/1/SE_Values_1.tscn")

var _SE_ENT_COLOR = Color.black
var _SE_ORD_COLOR = Color.green
var _SE_EGY_COLOR = Color.blue
var SE_COLOR_ALPHA = 0.7
var SE_ENT_COLOR = Color(_SE_ENT_COLOR.r, _SE_ENT_COLOR.g, _SE_ENT_COLOR.b, 0.7)
var SE_ORD_COLOR = Color(_SE_ORD_COLOR.r, _SE_ORD_COLOR.g, _SE_ORD_COLOR.b, 0.7)
var SE_EGY_COLOR = Color(_SE_EGY_COLOR.r, _SE_EGY_COLOR.g, _SE_EGY_COLOR.b, 0.7)
var SE_Values_BASIC_SPEED = 18

var time_speed = 1
var MIN_TIME_SPEED = 0.2
var MAX_TIME_SPEED = 10

var BLUE_NODE_COLOR = Color(0.19, 0.49, 0.76, 1)
var GREEN_NODE_COLOR = Color(0.28, 0.66, 0.3, 1)

var Nodes_locations = []
var Keys_locations = {}

var GENERATE_NODES_COUNT = 0#生成的节点数量
var GENERATE_RANDOM_DEGREE = 0#生成的节点混乱程度
var GENERATE_KEYS_DENSITY = 0#生成的键密度
var GENERATE_ENTROPY_DEGREE = 0#生成的熵程度
# Called when the node enters the scene tree for the first time.
func _ready():
	update_SE_Values_color()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_SE_Values_color():
	var SE_ENT_COLOR = Color(_SE_ENT_COLOR.r, _SE_ENT_COLOR.g, _SE_ENT_COLOR.b, SE_COLOR_ALPHA)
	var SE_ORD_COLOR = Color(_SE_ORD_COLOR.r, _SE_ORD_COLOR.g, _SE_ORD_COLOR.b, SE_COLOR_ALPHA)
	var SE_EGY_COLOR = Color(_SE_EGY_COLOR.r, _SE_EGY_COLOR.g, _SE_EGY_COLOR.b, SE_COLOR_ALPHA)

func custom_generate_world():
	var _locations = [Vector2(0, 0)]
	for i in GENERATE_NODES_COUNT:
		var new_location_found = false
		_locations.shuffle()
		for loc in _locations:
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
			if neighbors_count == 4:
				continue
			elif neighbors_count == 3:
				if randf() < GENERATE_RANDOM_DEGREE:
					continue
			elif neighbors_count == 2:
				var _ran = clamp(abs(GENERATE_RANDOM_DEGREE - 0.5) * 2, 0.01, 1)
				if randf() > _ran:
					continue
			elif neighbors_count == 1:
				if randf() > GENERATE_RANDOM_DEGREE:
					continue
			var target_loc = empty_locations[randi() % empty_locations.size()]
			new_location_found = true
			_locations.append(target_loc)
			break
		if !new_location_found:
			i += 1
	Nodes_locations = _locations.duplicate()
	
	yield(get_tree(), "idle_frame")
	
	var _Keys_locations = {}
	var _lonely_Nodes = _locations.duplicate()
	_lonely_Nodes.erase(Vector2(0, 0))
	var _size = _lonely_Nodes.size()
	while true:
		for i in _lonely_Nodes:
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
			if empty_neighbor_Keys_locations.size() == 0:
				pass
			else:
				while true:
					if empty_neighbor_Keys_locations.size() == 4:
						pass
					elif empty_neighbor_Keys_locations.size() == 0:
						break
					elif randf() > GENERATE_KEYS_DENSITY:
						break
					var _ran = empty_neighbor_Keys_locations[randi() % empty_neighbor_Keys_locations.size()]
					_new.append(_ran)
					empty_neighbor_Keys_locations.erase(_ran)
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
	yield(get_tree(), "idle_frame")
	Keys_locations = _Keys_locations.duplicate()
	pass
