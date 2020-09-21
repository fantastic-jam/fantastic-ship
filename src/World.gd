odextends Node2D

var _rotate_speed = 100
onready var _camera:Camera2D = get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rotate = Input.get_action_strength("rotate_world_left") - Input.get_action_strength("rotate_world_right")
	_camera.rotation_degrees = _camera.rotation_degrees + (rotate * delta * _rotate_speed)
