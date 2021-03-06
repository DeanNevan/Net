extends "res://Scripts/OrderNode.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	color = $Sprite2.modulate
	
	name_CN = "生产节点"
	detail = "-当周围没有 熵节点 或 熵大于0的 空节点，向 指定方向 发送【1能量】"
	introduction = "致敬伟大的生产者"
	$Sprite.visible = false
	$Sprite2.visible = true
	$Light2D.enabled = false
	$TextureProgress.visible = true
	max_bv = 8
	build_value = 0
	#modulate = Global.GREEN_NODE_COLOR
	max_ov = 4
	order_value = 4
	type = Global.NODE_TYPE.ORD_NODE
	$AnimationPlayer.play("working")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.playback_speed = Global.time_speed * 2

func work():
	if is_queued_for_deletion() or !is_instance_valid(self):
		return
	var _ord = order_value
	update_keys()
	update_neighbor_nodes()
	update_DirectionArrows()
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
	var _temp := false
	for i in neighbor_nodes:
		if i.type == Global.NODE_TYPE.ENT_NODE:
			_temp = true
		elif i.type == Global.NODE_TYPE.EMP_NODE and i.entropy_value > 0:
			_temp = true
	if !_temp:
		send_value_list.append([self, reverse_keys[direction], Global.VALUE_TYPE.EGY, 1])
	round_send_value_list = send_value_list.duplicate()
	emit_signal("send_value", send_value_list)
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
	$Sprite.visible = false
	$Sprite2.visible = true
	$TextureProgress.fill_mode = TextureProgress.FILL_BOTTOM_TO_TOP
	$TextureProgress.visible = true
	$TextureProgress.max_value = max_ov
	is_building = false
