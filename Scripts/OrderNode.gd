extends "res://Scripts/BasicNode.gd"

signal build_done
signal destroyed

var build_value = 10

var max_ov := 10
var order_value := 10

var is_building := true

var direction := 0

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
	$TextureProgress.max_value = build_value
	$TextureProgress.value = 0
	add_to_group("OrderNodes")
	connect("build_done", self, "_on_build_done")
	connect("selected", self, "show_DirectionArrows")
	for i in 4:
		DirectionArrows[i].pressed = false
		if keys.values().has(i):
			direction = i
			DirectionArrows[i].disabled = false
		else:
			DirectionArrows[i].disabled = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func build():
	if ENT > 0:
		destroyed(ENT)
	elif EGY > 0:
		build_value -= EGY
	TweenBuildProgress.interpolate_property($TextureProgress, "value", $TextureProgress.value, $TextureProgress.max_value - build_value, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenBuildProgress.start()
	if build_value <= 0:
		emit_signal("build_done")

func _on_build_done():
	$TextureProgress.visible = false
	$Sprite.visible = true
	$Sprite2.visible = true
	is_building = false

#被破坏
func destroyed(accepted_ENT):
	emit_signal("destroyed", self, accepted_ENT)
	remove_from_group("OrderNodes")
	remove_from_group("Nodes")

func assign_direction(new_direction):
	direction = new_direction

func show_DirectionArrows():
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
	pass

func play_animation():
	pass

func _set_DirectionArrows():
	for i in DirectionArrows:
		add_child(i)
		i.disabled = true
		i.connect("pressed", self, "_on_DirectionArrow0_pressed")
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
