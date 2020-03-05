extends "res://MainMenu/MainMenuNode.gd"

signal back

onready var TweenLabel = Tween.new()

var info_size = Vector2()

var is_displaying_child_nodes = false

var child_nodes = [
	preload("res://MainMenu/CustomStart/GenerateNodesCount.tscn"),
	preload("res://MainMenu/CustomStart/GenerateRandomDegree.tscn"),
	preload("res://MainMenu/CustomStart/GenerateKeysDensity.tscn"),
	preload("res://MainMenu/CustomStart/GenerateEntropyDegree.tscn"),
	preload("res://MainMenu/CustomStart/CustomStart.tscn")
]

var child_nodes_instances = []

onready var TweenScene = Tween.new()
func _init():
	is_choice_node = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$DirectionArrow.visible = false
	add_child(TweenScene)
	info_size = $Info.rect_size
	choice_node_color = $Sprite.modulate
	$Sprite.modulate = choice_node_color
	$Light2D.color = choice_node_color
	add_child(TweenLabel)
	cancel_select()
	connect("back", self, "_on_back")
	pass # Replace with function body.

func _unhandled_input(event):
	if get_parent().select_Node == self:
		if event.is_action_pressed("key_esc"):
			emit_signal("back")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	if !is_displaying_child_nodes:
		$DirectionArrow.visible = true
		is_displaying_child_nodes = true
		for i in child_nodes:
			var instance = i.instance()
			var new_location = location + instance.offset
			get_parent().nodes[new_location].queue_free()
			get_parent().nodes[new_location] = instance
			instance.location = new_location
			get_parent().add_child(instance)
			instance.set_position_with_location(instance.location)
			child_nodes_instances.append(instance)
			#print(instance)
	else:
		
		emit_signal("back")
	pass

func _on_back():
	$DirectionArrow.visible = false
	is_displaying_child_nodes = false
	for i in child_nodes_instances:
		#print(i)
		var new_Node = get_parent().EmptyNode.instance()
		new_Node.location = i.location
		get_parent().nodes[i.location] = new_Node
		get_parent().add_child(new_Node)
		new_Node.set_position_with_location(new_Node.location)
		i.queue_free()
	child_nodes_instances = []

func select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, info_size, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
	pass

func cancel_select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(info_size.x, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
