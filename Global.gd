extends Node

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
var MAX_TIME_SPEED = 12

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
