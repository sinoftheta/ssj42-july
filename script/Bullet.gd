extends Area2D

class_name Bullet
@export var velocity := Vector2.ZERO
var lifetime: float = 1
var alive_clock: float = 0
var pool: Pool

func _physics_process(delta):
	position += velocity * delta
	if alive_clock > 0:
		alive_clock -= delta
		if alive_clock <= 0:
			cleanup()

func set_pool(_pool: Pool):
	pool = _pool

func cleanup():
	pool.del(self)

func init():
	alive_clock = lifetime
