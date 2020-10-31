extends KinematicBody2D

var string_click := false
export var damage := 10
export var gravity := 8
export (PackedScene) var SugarEffect
var vel = Vector2.ZERO


var dropped := false


func _on_string_click():
	string_click = true

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	if collision_mask != 27:
		collision_mask = 27
	$HelthBar._on_max_health_updated(damage)
	$HelthBar._on_health_updated(damage, 0)
	SignalManager.connect("string_click", self, "_on_string_click")
	pass # Replace with function body.


func suggery_spread():
	var e = SugarEffect.instance()
	e.time = 0.2
	e.position = Vector2(e.position.x, e.position.y - 10)
	add_child(e)	
	
func _physics_process(delta):
	gravity()	
	vel = move_and_slide(vel, Vector2.UP)
	if is_on_floor() and not dropped:
		SignalManager.emit_signal("enemy_dropped", Vector2(position.x, position.y + 10))
		dropped = true
		suggery_spread()
	

func gravity():
	vel.y += gravity
	if vel.y > 800:
		vel.y = 800

func squash():
	scale = lerp(scale, Vector2(1.25, 0.25), 0.25)

func normal():
	scale = lerp(scale, Vector2(1, 1), 0.5)

func _on_Area2D_body_entered(body):
	if body.name == "Player":	
		if string_click and body.get_last_jump_status():
			damage -= body.get_damage()
			$HelthBar._on_health_updated(damage, 0)
			squash()
		if string_click and body.get_last_jump_status() and damage <= 0:
			queue_free()
#		print("string_click:", string_click)
#		print("body.get_last_jump_status():", body.get_last_jump_status())
		print("damage:", damage)


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		normal()
