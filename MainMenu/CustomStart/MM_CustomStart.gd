extends "res://MainMenu/MainMenuNode.gd"

signal change_to_scene(target_scene)

onready var TweenLabel = Tween.new()

var info_size = Vector2()

onready var TweenScene = Tween.new()
func _init():
	is_choice_node = true

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
#func _process(delta):
#	pass

func start():
	get_parent().is_working = false
	TweenScene.interpolate_property(get_parent().get_node("WorldEnvironment").environment, "adjustment_brightness", get_parent().get_node("WorldEnvironment").environment.adjustment_brightness, 0.01, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenScene.start()
	yield(TweenScene, "tween_completed")
	var CustomScene = load("res://CustomStartMenu/CustomStartMenu.tscn")
	get_tree().change_scene_to(CustomScene)
	pass

func select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, info_size, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
	pass

func cancel_select():
	TweenLabel.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(info_size.x, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLabel.start()
