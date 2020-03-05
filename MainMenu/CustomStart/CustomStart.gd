extends "res://MainMenu/MainMenuNode.gd"

signal count_up
signal cound_down

var offset = Vector2(-1, 0)

onready var TweenLabel = Tween.new()

var info_size = Vector2()

var main = preload("res://Main/Main.tscn")

func _init():
	is_choice_node = true
	offset = Vector2(-3, -2)

onready var TweenScene = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenScene)
	info_size = $Info.rect_size
	choice_node_color = $Sprite.modulate
	$Sprite.modulate = choice_node_color
	$Light2D.color = choice_node_color
	add_child(TweenLabel)
	cancel_select()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	TweenScene.interpolate_property(get_parent().get_node("WorldEnvironment").environment, "adjustment_brightness", get_parent().get_node("WorldEnvironment").environment.adjustment_brightness, 0.01, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenScene.start()
	Global.custom_generate_world()
	#print(Global.Nodes_locations)
	yield(get_tree().create_timer(1.5), "timeout")
	print("CHANGE")
	get_tree().change_scene_to(main)
	pass

func select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, info_size, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
	pass

func cancel_select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(info_size.x, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
