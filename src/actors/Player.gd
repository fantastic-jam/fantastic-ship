extends KinematicBody2D

export var _device = "0"
var type_name = "Player"

var _velocity = Vector2(0, 0)
var _gravity = 300
var _x_accel = 2000
var _x_drag = 800
var _max_speed = 300
var bump = Vector2(0, 0)

onready var _sprite = get_node('Sprite')

func _ready():
	pass # Replace with function body.

func _process(delta):
	var left = Input.get_action_strength("left_%s" % _device)
	var right = Input.get_action_strength("right_%s" % _device)

	var x = ((right - left) * _x_accel)
	if bump.x != 0:
		x = 0
		_velocity.x = bump.x
	if !is_on_floor():
		x = x/2
	var x_drag = 0
	if abs(_velocity.x) > 0.1:
		x_drag = -(_velocity.x / abs(_velocity.x)) * _x_drag
	if is_on_floor():
		x_drag = x_drag * 2

	var y = (_gravity + bump.y) * delta
	if is_on_floor() and Input.is_action_just_pressed("jump_%s" % _device):
		y = -200
	
	_velocity = _velocity + Vector2((x + x_drag) * delta, y)
	if _velocity.x < -_max_speed:
		_velocity.x = -_max_speed
	elif _velocity.x > _max_speed:
		_velocity.x = _max_speed

	if is_on_floor() and abs(x) > 0.1:
		_sprite.flip_h = x < 0
	if is_on_floor() and abs(_velocity.x) < 3:
			_sprite.play('Idle')
			_velocity.x = 0
	elif is_on_floor() and abs(_velocity.x) >= 3:
		_sprite.play('Run')
	if not is_on_floor():
		if _velocity.y <= 0:
			_sprite.play('Jump')
		else:
			_sprite.play('Fall')
	bump = Vector2(0, 0)
	
		
func _physics_process(delta):
	_velocity = move_and_slide(_velocity, Vector2.UP)
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		var collider = collision.collider
		if collider.get('type_name') == 'Player':
			bump = (position - collider.position).normalized() * 300
			collider.bump = -bump
