extends "res://Scripts/OrderNode.gd"

var target_direction_3_Nodes = []

func _ready():
	color = Color(0.21, 0.61, 1, 1)
	name_CN = "哨兵节点"
	detail = "-接收并消耗【1能量】：若 指定方向3格内 存在 熵节点，向其他方向 各发送【1能量】"
	introduction = "哨兵凝视深渊"
	$Sprite.visible = true
	$Sprite2.visible = true
	$Light2D.enabled = false
	$TextureProgress.visible = true
	max_bv = 12
	build_value = 0
	#modulate = Global.GREEN_NODE_COLOR
	max_ov = 6
	order_value = 6
	type = Global.NODE_TYPE.ORD_NODE
	$AnimationPlayer.play("working")
	#connect("direction_changed", self, "update_target_direction_3_Nodes")
	pass # Replace with function body.

func _draw():
	if is_selected:
		for i in target_direction_3_Nodes:
			if is_instance_valid(i):
				draw_circle(i.position - position + Vector2(Global.NODE_RADIUS / 1.2, -Global.NODE_RADIUS / 1.2), 33, color)
	else:
		draw_circle(Vector2(), 0, Color.aliceblue)

func _process(delta):
	update_target_direction_3_Nodes()
	update()
	$AnimationPlayer.playback_speed = Global.time_speed

func work():
	if is_queued_for_deletion() or !is_instance_valid(self):
		return
	var _ord = order_value
	update_keys()
	update_neighbor_nodes()
	update_DirectionArrows()
	update_target_direction_3_Nodes()
	if accepted_value.size() > 0:
		turn_on_lights(true, 1.2)
	if is_building:
		build()
		return
	if ENT > 0:
		_ord -= ENT
		ENT = 0
	if _ord <= 0:
		destroyed(abs(order_value))
		return
	_ord = clamp(_ord, 0, max_ov)
	TweenBuildProgress.interpolate_property($TextureProgress, "value", order_value, _ord, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenBuildProgress.start()
	order_value = _ord
	
	if EGY > 0:
		EGY -= 1
		var _has_ent_node = false
		for i in target_direction_3_Nodes:
			if i.type == Global.NODE_TYPE.ENT_NODE:
				_has_ent_node = true
				break
		if _has_ent_node:
			for t in keys:
				if keys[t] != direction:
					send_value_list.append([self, t, Global.VALUE_TYPE.EGY, 1])
	round_send_value_list = send_value_list.duplicate()
	emit_signal("send_value", send_value_list)
	emit_signal("done")
	pass

func update_target_direction_3_Nodes():
	if neighbor_nodes.size() == 0:
		return
	target_direction_3_Nodes = []
	for i in neighbor_nodes:
		if keys[neighbor_nodes[i]] == direction:
			target_direction_3_Nodes.append(i)
			break
	if target_direction_3_Nodes.size() == 0:
		return
	var _jud = false
	for i in target_direction_3_Nodes[0].neighbor_nodes:
		if target_direction_3_Nodes[0].keys[target_direction_3_Nodes[0].neighbor_nodes[i]] == direction:
			target_direction_3_Nodes.append(i)
			_jud = true
			break
	if !_jud:#如果目标方向第二格没有节点
		var _arr = []
		for i in target_direction_3_Nodes[0].neighbor_nodes:
			if i != self:
				target_direction_3_Nodes.append(i)
				_arr.append(i)
		for a in _arr:
			var _d = false
			for n in a.neighbor_nodes:
				if a.keys[a.neighbor_nodes[n]] == direction:
					target_direction_3_Nodes.append(n)
					_d = true
					break
			if !_d:
				for n in a.neighbor_nodes:
					target_direction_3_Nodes.append(n)
	else:
		var _d = false
		for i in target_direction_3_Nodes[1].neighbor_nodes:
			if target_direction_3_Nodes[1].keys[target_direction_3_Nodes[1].neighbor_nodes[i]] == direction:
				target_direction_3_Nodes.append(i)
				_d = true
				break
		if !_d:
			for i in target_direction_3_Nodes[1].neighbor_nodes:
				target_direction_3_Nodes.append(i)
	
	
	pass

func _on_Keys_work():
	EGY = 0
	ENT = 0
	ORD = 0
	accepted_value = []
	send_value_list = []
	turn_off_lights()

func _on_next_round():
	round_accepted_value.clear()
	round_send_value_list.clear()

func play_animation():
	pass

func _on_build_done():
	$TextureProgress.fill_mode = TextureProgress.FILL_BOTTOM_TO_TOP
	$TextureProgress.visible = true
	$TextureProgress.max_value = max_ov
	$TextureProgress.visible = true
	$Sprite.visible = true
	$Sprite2.visible = true
	is_building = false
