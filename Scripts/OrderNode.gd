extends "res://Scripts/BasicNode.gd"

signal build_done#信号：建造完成
signal destroyed#信号：摧毁
signal direction_changed#信号：方向改变

#最大建造值
var max_bv = 10

#建造值
var build_value = 0

#最大秩序值
var max_ov := 10

#秩序值
var order_value := 10

#建造的状态变量
var is_building := true

#如果该秩序节点需要玩家指示方向，direction表示该方向
var direction



onready var DirectionArrow0 = preload("res://Assets/SE/DirectionArrow/DirectionArrow.tscn").instance()
onready var DirectionArrow1 = preload("res://Assets/SE/DirectionArrow/DirectionArrow.tscn").instance()
onready var DirectionArrow2 = preload("res://Assets/SE/DirectionArrow/DirectionArrow.tscn").instance()
onready var DirectionArrow3 = preload("res://Assets/SE/DirectionArrow/DirectionArrow.tscn").instance()
onready var DirectionArrows = [DirectionArrow0, DirectionArrow1, DirectionArrow2, DirectionArrow3]

var TweenBuildProgress = Tween.new()
func _ready():
	add_child(TweenBuildProgress)
	_set_DirectionArrows()
	type = Global.NODE_TYPE.ORD_NODE
	
	TweenBuildProgress.interpolate_property($TextureProgress, "value", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenBuildProgress.start()
	
	add_to_group("OrderNodes")
	connect("build_done", self, "_on_build_done")
	connect("selected", self, "_on_OrderNode_selected")
	connect("cancel_select", self, "_on_OrderNode_cancel_select")
	
	update_DirectionArrows()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func build():
	
	if ENT > 0:
		destroyed(ENT)
	elif EGY > 0:
		build_value += EGY
	build_value += 1
	$TextureProgress.max_value = max_bv
	TweenBuildProgress.interpolate_property($TextureProgress, "value", $TextureProgress.value, build_value, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenBuildProgress.start()
	if build_value >= max_bv:
		emit_signal("build_done")
	emit_signal("done")
	

func _on_build_done():
	#$Sprite2.visible = true
	is_building = false

#被破坏
func destroyed(accepted_ENT):
	emit_signal("destroyed", self, accepted_ENT)
	remove_from_group("OrderNodes")
	remove_from_group("Nodes")

#节点被选中
func _on_OrderNode_selected(node):
	update_DirectionArrows()
	show_DirectionArrows(true)

#节点被取消选择
func _on_OrderNode_cancel_select(node):
	update_DirectionArrows()
	show_DirectionArrows(false)

#指定方向
func assign_direction(new_direction):
	direction = new_direction
	update_DirectionArrows()

func update_target_direction_3_Nodes():
	pass

#更新方向箭头
func update_DirectionArrows():
	if direction == null:
		for i in 4:
			if keys.values().has(i):
				direction = i
				break
	for i in 4:
		DirectionArrows[i].pressed = false
		if keys.values().has(i):
			DirectionArrows[i].disabled = false
		else:
			DirectionArrows[i].disabled = true
	match direction:
		0:
			DirectionArrow0.pressed = true
		1:
			DirectionArrow1.pressed = true
		2:
			DirectionArrow2.pressed = true
		3:
			DirectionArrow3.pressed = true

func show_DirectionArrows(is_show = true):
	for i in 4:
		DirectionArrows[i].visible = is_show
		DirectionArrows[i].modulate = color
	pass

func _on_mouse_entered():
	on_mouse = true

func _on_mouse_exited():
	on_mouse = false

func play_animation():
	pass

func _set_DirectionArrows():
	for i in 4:
		add_child(DirectionArrows[i])
		DirectionArrows[i].connect("right_mouse_button", self, "_on_DIrectionArrow_right_mouse_button")
		#DirectionArrows[i].mouse_filter = Control.MOUSE_FILTER_STOP
		#DirectionArrows[i].modulate = modulate
		DirectionArrows[i].disabled = true
		if i == 0:
			DirectionArrows[i].connect("pressed", self, "_on_DirectionArrow0_pressed")
		if i == 1:
			DirectionArrows[i].connect("pressed", self, "_on_DirectionArrow1_pressed")
		if i == 2:
			DirectionArrows[i].connect("pressed", self, "_on_DirectionArrow2_pressed")
		if i == 3:
			DirectionArrows[i].connect("pressed", self, "_on_DirectionArrow3_pressed")
	DirectionArrow1.set_rotation(PI / 2)
	DirectionArrow2.set_rotation(PI)
	DirectionArrow3.set_rotation(- PI / 2)
func _on_DirectionArrow0_pressed():
	assign_direction(0)
	DirectionArrow1.pressed = false
	DirectionArrow2.pressed = false
	DirectionArrow3.pressed = false
func _on_DirectionArrow1_pressed():
	assign_direction(1)
	DirectionArrow0.pressed = false
	DirectionArrow2.pressed = false
	DirectionArrow3.pressed = false
func _on_DirectionArrow2_pressed():
	assign_direction(2)
	DirectionArrow0.pressed = false
	DirectionArrow1.pressed = false
	DirectionArrow3.pressed = false
func _on_DirectionArrow3_pressed():
	assign_direction(3)
	DirectionArrow0.pressed = false
	DirectionArrow1.pressed = false
	DirectionArrow2.pressed = false
func _on_DIrectionArrow_right_mouse_button():
	if is_double_selected:
		emit_signal("cancel_double_select", self)
	if is_selected:
		emit_signal("cancel_select", self)
		is_double_selected = false
		is_selected = false
	pass
