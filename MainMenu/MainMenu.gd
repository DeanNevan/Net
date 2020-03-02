extends Node2D

signal to_up
signal to_left
signal to_down
signal to_right

var select_Node#当前选中
var target#目标
var is_moving = false

var color = Color.white

var camera_follow_target

var nodes := {}#{location:node}
var keys := {}#{location:key}

var visible_size = Vector2(18, 15)#可见范围

var x_min_to_max = Vector2(0, 17)
var y_min_to_max = Vector2(0, 14)

onready var SelectedAnimation = preload("res://Assets/SE/NodesSelected/NodesSelected.tscn").instance()

onready var EmptyNode = preload("res://MainMenu/MainMenuNode.tscn")
onready var Key = preload("res://MainMenu/MainMenuKey.tscn")

func _unhandled_input(event):
	if !is_moving:
		if event.is_action_pressed("key_w") or event.is_action_pressed("ui_up"):
			emit_signal("to_up")
			
			pass
		if event.is_action_pressed("key_a") or event.is_action_pressed("ui_left"):
			emit_signal("to_left")
			
			pass
		if event.is_action_pressed("key_s") or event.is_action_pressed("ui_down"):
			emit_signal("to_down")
			
			pass
		if event.is_action_pressed("key_d") or event.is_action_pressed("ui_right"):
			emit_signal("to_right")
			
			pass 

func _ready():
	randomize()
	add_child(SelectedAnimation)
	SelectedAnimation.play("nodes_selected")
	connect("to_right", self, "_on_to_right")
	connect("to_up", self, "_on_to_up")
	connect("to_left", self, "_on_to_left")
	connect("to_down", self, "_on_to_down")
	for x in visible_size.x:
		for y in visible_size.y:
			var new_Node = EmptyNode.instance()
			new_Node.location = Vector2(x, y)
			nodes[Vector2(x, y)] = new_Node
			add_child(new_Node)
			new_Node.set_position_with_location(new_Node.location)
			pass

	#生成竖着的键
	for x in visible_size.x:
		for y in visible_size.y - 1:
			var new_Key = Key.instance()
			new_Key.direction = 1
			new_Key.location = Vector2(x, y + 0.5)
			keys[Vector2(x, y + 0.5)] = new_Key
			add_child(new_Key)
			new_Key.set_position_with_location(new_Key.location, new_Key.direction)
	#生成横着的键
	for x in visible_size.x - 1:
		for y in visible_size.y:
			var new_Key = Key.instance()
			new_Key.direction = 0
			new_Key.location = Vector2(x + 0.5, y)
			keys[Vector2(x + 0.5, y)] = new_Key
			add_child(new_Key)
			new_Key.set_position_with_location(new_Key.location, new_Key.direction)
	
	is_moving = false
	select_Node = nodes[Vector2(floor(visible_size.x / 2), floor(visible_size.y / 2))]
	camera_follow_target = select_Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	SelectedAnimation.get_node("Sprite").position = select_Node.position
	SelectedAnimation.get_node("Light2D").position = select_Node.position
	SelectedAnimation.get_node("Sprite").modulate = select_Node.modulate
	SelectedAnimation.get_node("Light2D").color = select_Node.modulate
	if is_moving:
		if camera_follow_target != null and is_instance_valid(camera_follow_target):
			$Camera2D.position = camera_follow_target.global_position
		SelectedAnimation.get_node("Sprite").visible = false
		SelectedAnimation.get_node("Light2D").visible = false
	else:
		$Camera2D.position = select_Node.position
		SelectedAnimation.get_node("Sprite").visible = true
		SelectedAnimation.get_node("Light2D").visible = true

func display_Key_SE(key, direction1):
	is_moving = true
	var new_value = Global.SE_MainMenu_value.instance()
	new_value.direction = direction1
	#new_value.connect("end", self, "_on_SE_value_arrived")
	key.type = -1
	key.modulate = color
	key.add_child(new_value)
	new_value.start()
	camera_follow_target = new_value
	yield(new_value, "end")
	select_Node = target
	camera_follow_target = select_Node
	is_moving = false

func _on_to_right():
	target = nodes[Vector2(select_Node.location.x + 1, select_Node.location.y)]
	display_Key_SE(keys[(select_Node.location + target.location) / 2], -1)
	if target.location.x > ((x_min_to_max.y + x_min_to_max.x) / 2) + 1:
		x_min_to_max.y += 1
		x_min_to_max.x += 1
		for i in nodes.keys():
			if i.x < x_min_to_max.x:
				var node = nodes[i]
				nodes.erase(i)
				node.location = Vector2(x_min_to_max.y, i.y)
				node.set_position_with_location(node.location)
				nodes[node.location] = node
		for i in keys.keys():
			if i.x < x_min_to_max.x:
				var key = keys[i]
				keys.erase(i)
				if key.direction == 0:
					key.location = Vector2(x_min_to_max.y - 0.5, i.y)
				if key.direction == 1:
					key.location = Vector2(x_min_to_max.y, i.y)
				key.set_position_with_location(key.location, key.direction)
				keys[key.location] = key
	color_wave(0)
	#$Camera2D.position = target.position
	pass
func _on_to_up():
	target = nodes[Vector2(select_Node.location.x, select_Node.location.y - 1)]
	display_Key_SE(keys[(select_Node.location + target.location) / 2], 1)
	if target.location.y < ((y_min_to_max.x + y_min_to_max.y) / 2) - 1:
		y_min_to_max.y -= 1
		y_min_to_max.x -= 1
		for i in nodes.keys():
			if i.y > y_min_to_max.y:
				var node = nodes[i]
				nodes.erase(i)
				node.location = Vector2(i.x, y_min_to_max.x)
				node.set_position_with_location(node.location)
				nodes[node.location] = node
		for i in keys.keys():
			if i.y > y_min_to_max.y:
				var key = keys[i]
				keys.erase(i)
				if key.direction == 0:
					key.location = Vector2(i.x, y_min_to_max.x)
				if key.direction == 1:
					key.location = Vector2(i.x, y_min_to_max.x + 0.5)
				key.set_position_with_location(key.location, key.direction)
				keys[key.location] = key
	color_wave(3)
	#$Camera2D.position = target.position
	pass
func _on_to_left():
	target = nodes[Vector2(select_Node.location.x - 1, select_Node.location.y)]
	display_Key_SE(keys[(select_Node.location + target.location) / 2], 1)
	if target.location.x < ((x_min_to_max.x + x_min_to_max.y) / 2) - 1:
		x_min_to_max.y -= 1
		x_min_to_max.x -= 1
		for i in nodes.keys():
			if i.x > x_min_to_max.y:
				var node = nodes[i]
				nodes.erase(i)
				node.location = Vector2(x_min_to_max.x, i.y)
				node.set_position_with_location(node.location)
				nodes[node.location] = node
		for i in keys.keys():
			if i.x > x_min_to_max.y:
				var key = keys[i]
				keys.erase(i)
				if key.direction == 0:
					key.location = Vector2(x_min_to_max.x + 0.5, i.y)
				if key.direction == 1:
					key.location = Vector2(x_min_to_max.x, i.y)
				key.set_position_with_location(key.location, key.direction)
				keys[key.location] = key
	color_wave(2)
	#$Camera2D.position = target.position
	pass
func _on_to_down():
	target = nodes[Vector2(select_Node.location.x, select_Node.location.y + 1)]
	display_Key_SE(keys[(select_Node.location + target.location) / 2], -1)
	if target.location.y > ((y_min_to_max.x + y_min_to_max.y) / 2) + 1:
		y_min_to_max.y += 1
		y_min_to_max.x += 1
		for i in nodes.keys():
			if i.y < y_min_to_max.x:
				var node = nodes[i]
				nodes.erase(i)
				node.location = Vector2(i.x, y_min_to_max.y)
				node.set_position_with_location(node.location)
				nodes[node.location] = node
		for i in keys.keys():
			if i.y < y_min_to_max.x:
				var key = keys[i]
				keys.erase(i)
				if key.direction == 0:
					key.location = Vector2(i.x, y_min_to_max.y)
				if key.direction == 1:
					key.location = Vector2(i.x, y_min_to_max.y - 0.5)
				key.set_position_with_location(key.location, key.direction)
				keys[key.location] = key
	color_wave(1)
	#$Camera2D.position = target.position
	pass

func color_wave(direction = 0, space_time = 0.05):
	var new_color = Color(randf(), randf(), randf(), 1)
	color = new_color
	if direction == 0:
		for x in range(x_min_to_max.x, x_min_to_max.y + 1):
			for y in range(y_min_to_max.x, y_min_to_max.y + 1):
				nodes[Vector2(x, y)].smooth_change_color(new_color)
				if y != y_min_to_max.x:
					keys[Vector2(x, y - 0.5)].smooth_change_color(new_color)
				if x != x_min_to_max.y:
					keys[Vector2(x + 0.5, y)].smooth_change_color(new_color)
			yield(get_tree().create_timer(space_time), "timeout")
	if direction == 1:
		for y in range(y_min_to_max.x, y_min_to_max.y + 1):
			for x in range(x_min_to_max.x, x_min_to_max.y + 1):
				nodes[Vector2(x, y)].smooth_change_color(new_color)
				if x != x_min_to_max.x:
					keys[Vector2(x - 0.5, y)].smooth_change_color(new_color)
				if y != y_min_to_max.y:
					keys[Vector2(x, y + 0.5)].smooth_change_color(new_color)
			yield(get_tree().create_timer(space_time), "timeout")
	if direction == 2:
		var count = -1
		for x in range(x_min_to_max.x, x_min_to_max.y):
			count += 1
			for y in range(y_min_to_max.x, y_min_to_max.y):
				var loc = Vector2(x_min_to_max.y - count, y)
				nodes[loc].smooth_change_color(new_color)
				if y != y_min_to_max.x:
					keys[Vector2(loc.x, loc.y + 0.5)].smooth_change_color(new_color)
				if x != x_min_to_max.y:
					keys[Vector2(loc.x - 0.5, y)].smooth_change_color(new_color)
			yield(get_tree().create_timer(space_time), "timeout")
	if direction == 3:
		var count = -1
		for y in range(y_min_to_max.x, y_min_to_max.y):
			count += 1
			for x in range(x_min_to_max.x, x_min_to_max.y):
				var loc = Vector2(x, y_min_to_max.y - count)
				nodes[loc].smooth_change_color(new_color)
				if x != x_min_to_max.x:
					keys[Vector2(loc.x + 0.5, loc.y)].smooth_change_color(new_color)
				if y != y_min_to_max.y:
					keys[Vector2(x, loc.y - 0.5)].smooth_change_color(new_color)
			yield(get_tree().create_timer(space_time), "timeout")
	
