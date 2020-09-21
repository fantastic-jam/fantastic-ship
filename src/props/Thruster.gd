class_name Thruster
extends Node2D

export var position_in_ship = 'left'

var _shutdown = false
signal thruster_repaired(thruster)

onready var _panel_sprite = get_node('Panel/Sprite')
onready var _sprite = get_node('Sprite')


func _ready():
	get_node("/root/World").register_thruster(self)

func set_shutdown(shutdown: bool) -> void :
	_shutdown = shutdown
	if shutdown:
		_panel_sprite.play('failure')
	else:
		print("emit_signal('thruster_repaired', self)")
		emit_signal('thruster_repaired', self)
		_panel_sprite.play('default')
	_sprite.visible = not shutdown

func is_shutdown() -> bool:
	return _shutdown


func _on_rightthruster_thruster_repaired():
	pass # Replace with function body.
