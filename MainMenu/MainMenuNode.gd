extends Node2D

signal selected(node)


var is_choice_node = false
var choice_node_color = Color.white
var scene

var light_scale = 1
var is_smoothing_change_light_energy = false

var location := Vector2()

var on_mouse = false

onready var TweenLightEnergy = Tween.new()
onready var TweenColor = Tween.new()
onready var TweenScale = Tween.new()

onready var LiveLightTimer = Timer.new()
func _ready():
	add_child(LiveLightTimer)
	LiveLightTimer.connect("timeout", self, "_on_LiveLightTimer_timeout")
	#LiveLightTimer.start(0.6)
	add_child(TweenLightEnergy)
	add_child(TweenColor)
	add_child(TweenScale)
	
	#live_light()
	#$Area2D.connect("mouse_entered", self, "_on_mouse_entered")
	#$Area2D.connect("mouse_exited", self, "_on_mouse_exited")

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().select_Node.is_choice_node:
		$Sprite.material.light_mode = $Sprite.material.LIGHT_MODE_NORMAL
		light_scale = 1
	else:
		$Sprite.material.light_mode = $Sprite.material.LIGHT_MODE_LIGHT_ONLY
		var length = ceil(abs((get_parent().select_Node.location - location).length()))
		light_scale = clamp(1 - (length * 0.25), 0, 1)
	if !is_smoothing_change_light_energy and !TweenLightEnergy.is_active():
		live_light()
	if is_choice_node:
		light_scale *= 1.6

func live_light():
	TweenLightEnergy.stop_all()
	TweenLightEnergy.interpolate_property($Light2D, "energy", $Light2D.energy, 1.1 * light_scale, 1.6, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLightEnergy.start()
	yield(TweenLightEnergy, "tween_completed")
	TweenLightEnergy.stop_all()
	TweenLightEnergy.interpolate_property($Light2D, "energy", $Light2D.energy, 0.6 * light_scale, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenLightEnergy.start()
	yield(TweenLightEnergy, "tween_completed")
	pass

func _on_LiveLightTimer_timeout():
	LiveLightTimer.start(1)
	if !is_smoothing_change_light_energy:
		live_light()

func _on_mouse_entered():
	on_mouse = true

func _on_mouse_exited():
	on_mouse = false

func set_position_with_location(new_location):
	global_position = new_location * (Global.NODE_RADIUS * 2 + Global.KEY_LENGTH)

func smooth_change_color(target_color, change_speed = 0.5):
	if is_choice_node:
		return
	TweenColor.interpolate_property(self, "modulate", modulate, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenColor.interpolate_property($Light2D, "color", $Light2D.color, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenColor.start()

func smooth_change_scale(target_scale = Vector2(1.3, 1.3), change_speed = 0.15):
	TweenScale.stop_all()
	TweenScale.interpolate_property(self, "scale", scale, target_scale, change_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenScale.start()
	yield(TweenScale, "tween_completed")
	TweenScale.stop_all()
	TweenScale.interpolate_property(self, "scale", scale, Vector2(1, 1), change_speed / 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenScale.start()

func smooth_change_light_energy(target_energy = 2, change_speed = 0.5):
	is_smoothing_change_light_energy = true
	#var egy = $Light2D.energy
	TweenLightEnergy.stop_all()
	TweenLightEnergy.interpolate_property($Light2D, "energy", $Light2D.energy, target_energy * light_scale, change_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLightEnergy.start()
	yield(TweenLightEnergy, "tween_completed")
	TweenLightEnergy.interpolate_property($Light2D, "energy", $Light2D.energy, 1 * light_scale, change_speed / 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenLightEnergy.start()
	yield(TweenLightEnergy, "tween_completed")
	TweenLightEnergy.stop_all()
	is_smoothing_change_light_energy = false
