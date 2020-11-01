extends Node2D


export (float) var length = 30
export (float) var constrain = 1
export (Vector2) var gravity = Vector2(0,9.8)
export (float) var friction = 0.9
export (bool) var start_pin = true
export (bool) var end_pin = true
export (PackedScene) var SugarEffect

# custom my code
var screensize
var shape = CollisionPolygon2D.new()
var ground = Polygon2D.new()
var texture_2 = preload("res://assets/dark_brown.png")
var texture = preload("res://assets/brown.png")
var string_pull = false
var string_pull_height = 0
var string_collide = false
var string_pull_count = 0
var string_pull_vec = Vector2()
export var string_pull_impact = Vector2(0, 50)
export var horizontal = true
export var top = false
export var bottom = false
export var enable_texture = true
export var initial_position = Vector2.ZERO
export var active_string = true

var pos: PoolVector2Array
var pos_ex: PoolVector2Array
var count: int

func suggery_spread(p):
	if not SugarEffect:
		return
	var e = SugarEffect.instance()
	e.time = 0.2
	e.position = Vector2(p.x, p.y - 10)
	add_child(e)
	
	
func _on_sweet_spawned(e):
	if bottom:
		return
	string_shake(e)
	
func _on_enemy_dropped(e):
	if top:
		return
	string_shake(e)

func _on_player_floor(state, jelly, jumped, height):
	string_collide = state
	string_pull = jumped
	if jumped:
		string_pull_count = 0
	if height:
		string_pull_height = height
	string_pull_vec = jelly.position

func _ready():
	screensize = get_viewport().get_visible_rect().size
	count = get_count(length)
	resize_arrays()
	init_position()
	$StaticBody2D.add_child(shape)	
	if enable_texture:
		ground.texture = texture
		if top:
			ground.texture = texture_2
		add_child(ground)		
	SignalManager.connect("on_floor", self, "_on_player_floor")
	SignalManager.connect("sweet_spawned", self, "_on_sweet_spawned")
	SignalManager.connect("enemy_dropped", self, "_on_enemy_dropped")


func get_count(distance: float):
	var new_count = ceil(distance / constrain)
	return new_count

func resize_arrays():
	pos.resize(count)
	pos_ex.resize(count)

func init_position():
	for i in range(count):
#		horizontal
		if horizontal:
			pos[i] = position + Vector2(constrain *i, 0)
			pos_ex[i] = position + Vector2(constrain *i, 0)
#		vertical
		if !horizontal:
			pos[i] = position + Vector2(0, constrain *i)
			pos_ex[i] = position + Vector2(0, constrain *i)
	position = initial_position
	
var relased = false
var lastX = 0
var area = 1
var bounceBack = 0

func string_shake(vec):
#	if !string_pull and string_collide and string_pull_count == 0 and active_string:
	if top:
		AudioManager.play("res://assets/sounds/waterdrip_1.wav")
	var i = floor(vec.x)
	if string_pull_impact.x != 0:
		vec.x = vec.x + string_pull_impact.x
	if string_pull_impact.y != 0:
		vec.y = vec.y + string_pull_impact.y
	for x in range (area):
		if i+x >= len(pos):
			continue
		pos_ex[i+x] = pos[i+x]
		pos_ex[i-x] = pos[i-x]
		pos[i+x] = vec
		pos[i-x] = vec
	string_pull = true
	string_pull_count = 1
	if top:
		active_string = false
func _process(delta):
	if !string_pull and string_collide and string_pull_count == 0 and active_string:
		print("position:",string_pull_vec)
		if top:
			return
		string_shake(string_pull_vec)
	if Input.is_action_just_released("click"):
		if not active_string:
			return
		relased = true
	
	if Input.is_action_just_pressed("click"):
		AudioManager.play("res://assets/sounds/waterdrip_2.wav")
		SignalManager.emit_signal("string_click")
		suggery_spread(get_global_mouse_position())
			
	if Input.is_action_pressed("click"):
		if not active_string:
			return
		SignalManager.emit_signal("string_click")
		relased = false	#Move start point
		var i = floor(get_global_mouse_position().x)
		if lastX == 0:
			lastX = get_global_mouse_position().x
		if i >= len(pos):
			return
			
		for x in range (area):
			if i+x >= len(pos):
				continue
			pos_ex[i+x] = pos[i+x]
			pos_ex[i-x] = pos[i-x]
			pos[i+x] = get_global_mouse_position()
			pos[i-x] = get_global_mouse_position()
			

#	if !relased:
#		gravity.y = 9.8	
#		print("gravity:", gravity)
	
	if relased:
#		gravity.y = -400
#		print("gravity:", gravity)
		
		var i = floor(lastX)
		if i >= len(pos):
			return
		for x in range (20):
			if i+x >= len(pos):
				continue
			pos[i+x] = pos_ex[i+x]
			pos[i-x] = pos_ex[i-x]	
			if i != 0:
				pos[i+x].y = pos_ex[i+x].y + bounceBack
#				pos[i-x].y = pos_ex[i-x].y + -1
				
		lastX = 0
	for i in range(2):
		update_points(delta)
		update_distance()
	
	$Line2D.points = pos
	
#	collision
#	print("poly size", len(poly))
	var poly = PoolVector2Array()
	var poly2 = PoolVector2Array()
	for i in range (len(pos)):
		if i % 10 != 0:
			continue
		poly.append(pos[i])	
#
	var y = 0
	var x = 0
	if top and horizontal:
		y = -100
	if bottom:
		y = screensize.y
	poly.append(Vector2(pos[-1].x + x, y))
	poly.append(Vector2(pos[0].x + x, y))
	shape.polygon = poly
	
	poly2 = pos
	poly2.append(Vector2(pos[-1].x + x, y))
	poly2.append(Vector2(pos[0].x + x, y))
	ground.polygon = poly2
	
	
func update_points(delta):
	for i in range (count):
		# not first and last || first if not pinned || last if not pinned
		if (i!=0 && i!=count-1) || (i==0 && !start_pin) || (i==count-1 && !end_pin):
			var vec2 = (pos[i] - pos_ex[i]) * friction
			pos_ex[i] = pos[i]
			pos[i] += vec2 + (gravity * delta * delta)

func update_distance():
	for i in range(count):
		if i == count-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		if i == 0:
			if start_pin:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		elif i == count-1:
			pass
		else:
			if i+1 == count-1 && end_pin:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)


