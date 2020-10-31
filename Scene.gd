extends Node2D

const Enemy = preload("res://EnemyKK.tscn")
var screensize

func _ready():
	screensize = get_viewport().get_visible_rect().size
	AudioManager.play("res://assets/sounds/bg_music_chill.ogg")
	spawn_enemies(10, 3)
	
func spawn_enemies(n, time):
	for i in range (n):
		yield(get_tree().create_timer(time), "timeout")
		randomize()
		var x = rand_range(50, screensize.x - 50)
		var y = rand_range(120, 140)
		var e = Enemy.instance()
		e.collision_mask = 26
		e.position = Vector2(x, 0)
		$Enemies.add_child(e)
		SignalManager.emit_signal("sweet_spawned", Vector2(e.position.x, y))
		
	
func _process(delta):
	pass
