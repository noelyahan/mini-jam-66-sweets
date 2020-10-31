extends KinematicBody2D

export var jump_power = 800
export var min_jump_power = 600
export var jump_control_diff = 50

var stopping_friction = 0.6
var dash_direction := Vector2(1, 0)
var gravity = 30
var vel = Vector2()
var screensize
var dashing := false

signal on_floor(state, player, jumped, height)


func _ready():
	screensize = get_viewport().get_visible_rect().size
	
func play_jump_sound():
	AudioManager.play("res://assets/sounds/bloop.wav")
	pass

var jumped = false
func _physics_process(delta):
	gravity()
	friction()
#	dash()
#	look_at(get_global_mouse_position())
	if Input.is_action_just_released("click"):
		var dis = get_global_mouse_position().distance_to(global_position)
		var jp = range_lerp(abs(dis), 0, jump_control_diff, min_jump_power, jump_power)
		jumped = true	
		if dis < jump_control_diff:	
			emit_signal("on_floor", is_on_floor(), self, true, jp)	
			jump(jp)
	if is_on_floor():		
		emit_signal("on_floor", is_on_floor(), self, false, null)
		scale = lerp(scale, Vector2(1.25, 0.50), 0.25)
		jumped = false
	if not is_on_floor() and jumped:
		scale = lerp(scale, Vector2(1, 1), 0.25)
	if vel.y > 100:
		jumped = true
	vel = move_and_slide(vel, Vector2.UP)

func jump(power):
	play_jump_sound()
	if vel.y > 0: vel.y = 0
	vel.y -= power
	pass


func gravity():
	if not dashing:
		vel.y += gravity
	if vel.y > 800:
		vel.y = 800

func friction():
	vel.x *= stopping_friction
	
func dash():
	if is_on_floor():
		return
	if Input.is_action_just_released("right_click"):
		var diff = get_global_mouse_position().x - global_position.x
		var y = 0
		dash_direction = Vector2(1, y)
		if diff < 0:
			dash_direction = Vector2(-1, y)
		vel = dash_direction.normalized() * 2000
		dashing = true
		emit_signal("on_floor", is_on_floor(), self, true, null)	
		yield(get_tree().create_timer(0.5), "timeout")
		dashing = false	
