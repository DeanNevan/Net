extends TextureRect

var target

onready var MainScene = get_parent().get_parent()

onready var Tween1 = Tween.new()
func _ready():
	rect_scale.y = 0
	add_child(Tween1)
	MainScene.connect("selected", self, "_on_selected")
	MainScene.connect("cancel_select", self, "_on_cancel_select")
	#MainScene.connect("next_rount", self, "_on_next_round")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rect_scale.y < 0.01:
		visible = false
	else:
		visible = true
	if target != null and is_instance_valid(target):
		$Title.modulate = target.color
		$InIcon.modulate = target.color
		$OutIcon.modulate = target.color
		$RichTextLabel.modulate = target.color
		$RichTextLabel.bbcode_text = "[center]" + str(target.name_CN) + "[/center]" + "\n" + "\n"
		if target.has_method("update_nodes"):
			$RichTextLabel.bbcode_text += "状态："
			if target.send_value_list.size() > 0:
				$RichTextLabel.bbcode_text += "运作"
			else:
				$RichTextLabel.bbcode_text += "空闲"
		if target.has_method("update_keys"):
			match target.type:
				Global.NODE_TYPE.ENT_NODE:
					$RichTextLabel.bbcode_text += "超熵值：" + str(target.super_entropy_value) + "/" + str(target.max_sev) + "\n" + "\n"
					$RichTextLabel.bbcode_text += "状态："
					if target.accepted_value.size() > 0:
						$RichTextLabel.bbcode_text += "运作"
					else:
						$RichTextLabel.bbcode_text += "空闲"
				Global.NODE_TYPE.EMP_NODE:
					$RichTextLabel.bbcode_text += "熵值：" + str(target.entropy_value) + "/" + str(target.max_ev) + "\n" + "\n"
					$RichTextLabel.bbcode_text += "状态："
					if target.accepted_value.size() > 0:
						$RichTextLabel.bbcode_text += "运作"
					else:
						$RichTextLabel.bbcode_text += "空闲"
				Global.NODE_TYPE.ORD_NODE:
					$RichTextLabel.bbcode_text += "秩序值：" + str(target.order_value) + "/" + str(target.max_ov) + "\n" + "\n"
					$RichTextLabel.bbcode_text += "状态："
					if target.is_building:
						$RichTextLabel.bbcode_text += "建造中，建造值：" + str(target.build_value) + "/" + str(target.max_bv)
					else:
						if target.accepted_value.size() > 0:
							$RichTextLabel.bbcode_text += "运作"
						else:
							$RichTextLabel.bbcode_text += "空闲"
			
		$RichTextLabel.bbcode_text += "\n" + "\n"
		$RichTextLabel.bbcode_text += "说明：" + "\n" + target.detail
		$RichTextLabel.bbcode_text += "[center]———————————————————[/center]"
		$RichTextLabel.bbcode_text += "[right]“" + target.introduction + "”[/right]"
		$RichTextLabel.bbcode_text += "[center]———————————————————[/center]"
		pass
	else:
		$RichTextLabel.bbcode_text = ""
		
	
	if target != null and is_instance_valid(target):
		var EGY_dic = {0:{0:0,1:0,2:0,3:0},1:{0:0,1:0,2:0,3:0}}
		var ORD_dic = {0:{0:0,1:0,2:0,3:0},1:{0:0,1:0,2:0,3:0}}
		var ENT_dic = {0:{0:0,1:0,2:0,3:0},1:{0:0,1:0,2:0,3:0}}
		if target.has_method("update_nodes"):
			for i in target.round_send_value_list:
				match i[2]:
					Global.VALUE_TYPE.EGY:
						EGY_dic[1][target.nodes[i[1]]] += i[3]
					Global.VALUE_TYPE.ORD:
						ORD_dic[1][target.nodes[i[1]]] += i[3]
					Global.VALUE_TYPE.ENT:
						ENT_dic[1][target.nodes[i[1]]] += i[3]
		elif target.has_method("update_keys"):
			for i in target.round_accepted_value:
				match i[1]:
					Global.VALUE_TYPE.EGY:
						EGY_dic[0][target.keys[i[0]]] += i[2]
					Global.VALUE_TYPE.ORD:
						ORD_dic[0][target.keys[i[0]]] += i[2]
					Global.VALUE_TYPE.ENT:
						ENT_dic[0][target.keys[i[0]]] += i[2]
			for i in target.round_send_value_list:
				match i[2]:
					Global.VALUE_TYPE.EGY:
						EGY_dic[1][target.keys[i[1]]] += i[3]
					Global.VALUE_TYPE.ORD:
						ORD_dic[1][target.keys[i[1]]] += i[3]
					Global.VALUE_TYPE.ENT:
						ENT_dic[1][target.keys[i[1]]] += i[3]
		$EGY.display(EGY_dic)
		$ORD.display(ORD_dic)
		$ENT.display(ENT_dic)
		pass
	else:
		$EGY.clear()
		$ORD.clear()
		$ENT.clear()
	pass

func _on_selected(NodeOrKey):
	Tween1.stop_all()
	Tween1.interpolate_property(self, "rect_scale", Vector2(rect_scale.x, 0), Vector2(rect_scale.x, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	target = NodeOrKey
	pass

func _on_cancel_select():
	Tween1.interpolate_property(self, "rect_scale", rect_scale, Vector2(rect_scale.x, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	target = null

func _on_next_round():
	pass
