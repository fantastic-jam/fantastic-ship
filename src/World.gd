extends Node2D

var _rotate_speed = 30
onready var _camera:Camera2D = get_node("Camera2D")
onready var _player = get_node("AudioStreamPlayer")

var _up_sound = preload("res://assets/snd/up.wav")
var _failure_sound = preload("res://assets/snd/failure.wav")

var rng = RandomNumberGenerator.new()

var _thrusters = []

var _left_thruster = 0
var _right_thruster = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var right_offline = 0
	var left_offline = 0
	for i in range(_thrusters.size()):
		if _thrusters[i].is_shutdown():
			if _thrusters[i].position_in_ship == 'left':
				left_offline += 1
			else:
				right_offline += 1
	var rotate = left_offline - right_offline
	_camera.rotation_degrees = _camera.rotation_degrees + (rotate * delta * _rotate_speed)
	if Input.is_action_just_pressed('reset'):
		var _err = get_tree().reload_current_scene()

func register_thruster(thruster: Node2D) -> void:
	if thruster.position_in_ship == 'left':
		_left_thruster+=1
	else:
		_right_thruster+=1

	var idx = _thrusters.size()
	#print('thruster %s at %s registered at position %s' % [thruster, idx, thruster.position_in_ship ])
	var _err = thruster.connect('thruster_repaired', self, "_on_thruster_repaired", [idx])
	_thrusters.append(thruster)

func _on_thruster_repaired(thruster:Node2D, idx: int):
	#print('thruster %s at position %s repaired' % [idx, thruster.position_in_ship])
	play_sound(_up_sound)

func _on_ShutdownTimer_timeout():
	var idx = rng.randi() % 10
	if idx < _thrusters.size() and not _thrusters[idx].is_shutdown():
		_thrusters[idx].set_shutdown(true)
		play_sound(_failure_sound)


func play_sound(sound: AudioStream) -> void:
	_player.stream = sound
	_player.play()
					
