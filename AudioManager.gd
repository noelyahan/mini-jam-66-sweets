extends Node

var num_players = 8
var bus = "master"

var available = []  # The available players.

var queue = []  # The queue of sounds to play.

var loaded = []


func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus

	
func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_path):
	for l in loaded:
		if l == sound_path && sound_path == "res://assets/sounds/bg_music_chill.ogg":
			return
	loaded.append(sound_path)
	queue.append(sound_path)


func _process(delta):
	# Play a queued sound if any players are available.

	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
