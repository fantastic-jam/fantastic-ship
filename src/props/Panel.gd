extends Node2D

onready var _parent = get_parent()

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body is Player and _parent.is_shutdown():
		_parent.set_shutdown(false)

