extends Node2D

const Enemy = preload("res://EnemyKK.tscn")
var screensize

func _ready():
	screensize = get_viewport().get_visible_rect().size
	AudioManager.play("res://assets/sounds/bg_music.ogg")
	spawn_enemies()
	
func spawn_enemies():
	for i in range (100):
		randomize()
		var x = rand_range(0, screensize.x - 10)
		var y = rand_range(120, 150)
		var e = Enemy.instance()
		e.position = Vector2(x, y)
		$Enemies.add_child(e)
		SignalManager.emit_signal("sweet_spawned", Vector2(e.position.x, 135))
		yield(get_tree().create_timer(1.5), "timeout")
	
func _process(delta):
	pass
