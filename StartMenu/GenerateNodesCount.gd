extends "res://StartMenu/ProgressBall.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	
	max_value = Global.MAX_NODES_COUNT
	value = 0
	update_text()
	connect("value_changed", self, "maichong")
	#connect("value_changed", self, "update_text")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_text()

func maichong(a):
	if !can_maichong:
		return
	can_maichong = false
	maichongTimer.start(0.3)
	if randf() <= 0.5:
		get_parent().generate_SE_values(get_parent().get_node("NormalKey1"))
		yield(get_tree().create_timer(0.65), "timeout")
		get_parent().generate_SE_values(get_parent().get_node("NormalKey2"))
	else:
		get_parent().generate_SE_values(get_parent().get_node("NormalKey3"))
		yield(get_tree().create_timer(0.65), "timeout")
		get_parent().generate_SE_values(get_parent().get_node("NormalKey4"))
	yield(get_tree().create_timer(0.7), "timeout")
	get_parent().generate_SE_values(get_parent().get_node("NormalKeyEnd"))
	

func update_text():
	$Label.text = "节点数量" + "\n" + str(value)
