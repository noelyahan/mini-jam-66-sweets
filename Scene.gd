extends Node2D

const Enemy = preload("res://EnemyKK.tscn")
var screensize
export var enemy_count = 10

func _on_enemy_count_updated(c):
	if c <= 1:
		spawn_enemies(enemy_count, 3)
	

func _ready():
	screensize = get_viewport().get_visible_rect().size
	AudioManager.play("res://assets/sounds/bg_music.ogg")
	SignalManager.connect("enemy_count_updated", self, "_on_enemy_count_updated")	
	spawn_enemies(enemy_count, 3)
	
func spawn_enemies(n, time):
	StatsManager.update_enemy_count(enemy_count)	
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
