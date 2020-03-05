extends "res://MainMenu/MainMenuNode.gd"

signal count_up
signal cound_down

var offset = Vector2(0, -1)

var count = 0.1

onready var TweenLabel = Tween.new()

var info_size = Vector2()

func _init():
	is_choice_node = true
	offset = Vector2(-1, -2)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label2.text = str(count)
	connect("count_up", self, "_on_count_up")
	connect("cound_down", self, "_on_count_down")
	info_size = $Info.rect_size
	choice_node_color = $Sprite.modulate
	$Sprite.modulate = choice_node_color
	$Light2D.color = choice_node_color
	add_child(TweenLabel)
	cancel_select()
	pass # Replace with function body.


func _process(delta):
	Global.GENERATE_KEYS_DENSITY = count
	if get_parent().select_Node == self:
		if Input.is_action_pressed("key_q"):
			emit_signal("cound_down")
		if Input.is_action_pressed("key_e"):
			emit_signal("count_up")
	pass

func start():
	count = (rand_range(10, 100)) / 100
	$Label2.text = str(count)
	pass

func _on_count_up():
	count += 0.01
	count = clamp(count, 0.1, 1)
	$Label2.text = str(count)
	pass

func _on_count_down():
	count -= 0.01
	count = clamp(count, 0.1, 1)
	$Label2.text = str(count)
	pass

func select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, info_size, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
	pass

func cancel_select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(info_size.x, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
