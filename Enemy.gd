extends KinematicBody2D

var string_click := false
export var damage := 10
export var gravity := 10
var vel = Vector2.ZERO

func _on_string_click():
	string_click = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$HelthBar._on_max_health_updated(damage)
	$HelthBar._on_health_updated(damage, 0)
	SignalManager.connect("string_click", self, "_on_string_click")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	gravity()
	vel = move_and_slide(vel, Vector2.UP)

func gravity():
	vel.y += gravity
	if vel.y > 800:
		vel.y = 800

func _on_Area2D_body_entered(body):
	if body.name == "Player":	
		if string_click and body.get_last_jump_status():
			damage -= body.get_damage()
			$HelthBar._on_health_updated(damage, 0)
		if string_click and body.get_last_jump_status() and damage <= 0:
			queue_free()
		print("string_click:", string_click)
		print("body.get_last_jump_status():", body.get_last_jump_status())
		print("damage:", damage)
