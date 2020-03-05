extends Node2D


var location := Vector2()
var direction := 0

var light_scale = 1
var is_smoothing_change_light_energy = false

onready var TweenLightEnergy = Tween.new()
onready var TweenColor = Tween.new()
onready var TweenScale = Tween.new()

onready var LiveLightTimer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(LiveLightTimer)
	LiveLightTimer.connect("timeout", self, "_on_LiveLightTimer_timeout")
	#LiveLightTimer.start(0.6)
	add_child(TweenLightEnergy)
	add_child(TweenColor)
	add_child(TweenScale)
	#live_light()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().select_Node.is_choice_node:
		#$Sprite.material.light_mode = $Sprite.material.LIGHT_MODE_NORMAL
		var length = ceil(abs((get_parent().select_Node.location - location).length()))
		light_scale = clamp(1 - (length * 0.2), 0, 1)
		if !TweenLightEnergy.is_active():
			TweenLightEnergy.interpolate_property($Light2D, "energy", $Light2D.energy, 1 * light_scale, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			TweenLightEnergy.start()
	else:
		#$Sprite.material.light_mode = $Sprite.material.LIGHT_MODE_LIGHT_ONLY
		var length = ceil(abs((get_parent().select_Node.location - location).length()))
		light_scale = clamp(1 - (length * 0.28), 0, 1)
	if !is_smoothing_change_light_energy and !TweenLightEnergy.is_active():
		live_light()

func _on_LiveLightTimer_timeout():
	LiveLightTimer.start(1)
	if !is_smoothing_change_light_energy:
		live_light()

func live_light():
	TweenLightEnergy.interpolate_property($Light2D, "energy", $Light2D.energy, 1 * light_scale, 1.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenLightEnergy.start()
	yield(TweenLightEnergy, "tween_completed")
	TweenLightEnergy.interpolate_property($Light2D, "energy", $Light2D.energy, 0.5 * light_scale, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenLightEnergy.start()
	yield(TweenLightEnergy, "tween_completed")

func set_position_with_location(new_location, new_direction):
	rotation_degrees = new_direction * 90
	global_position = new_location * (Global.NODE_RADIUS + (Global.KEY_LENGTH / 2)) * 2

func smooth_change_color(target_color, change_speed = 0.5):
	TweenColor.interpolate_property(self, "modulate", modulate, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenColor.interpolate_property($Light2D, "color", $Light2D.color, target_color, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenColor.start()

func smooth_change_scale(target_scale = Vector2(1.3, 1.3), change_speed = 0.15):
	TweenScale.stop_all()
	TweenScale.interpolate_property(self, "scale", scale, Vector2(2.12 - target_scale.x, target_scale.y), change_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenScale.start()
	yield(TweenScale, "tween_completed")
	TweenScale.stop_all()
	TweenScale.interpolate_property(self, "scale", scale, Vector2(1, 1), change_speed / 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenScale.start()

func smooth_change_light_energy(target_energy = 2, change_speed = 0.4):
	
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
