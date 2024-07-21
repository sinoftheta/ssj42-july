extends Area2D

class_name Weapon
#@export var bullet_scene: PackedScene
@export var max_ammo = 30
var ammo = -1
@export var bullet_speed: float = 600
@export var fire_cooldown: float = 0.3
@export var bullet_count: int = 1
@export var arc: float = 45
var fire_clock: float = 0
var root: Node2D
var drop_clock: float = 0

func _ready():
	root = get_parent()
	if max_ammo > 0:
		ammo = max_ammo

func _physics_process(delta):
	if fire_clock > 0:
		fire_clock -= delta
	if drop_clock > 0:
		drop_clock -= delta

func fire() -> bool:
	if fire_clock > 0 or ammo == 0:
		return false
	fire_clock = fire_cooldown
	ammo -= 1
	#var bullet := bullet_scene.instantiate() as Bullet
	var angle = global_rotation - deg_to_rad(arc) / 2
	var angle_change = deg_to_rad(arc) / (bullet_count + 1)
	for i in range(bullet_count):
		var bullet = Globals.bullet_pool.get_new() as Bullet
		angle += angle_change
		root.add_child(bullet)
		bullet.position = global_position
		bullet.velocity = Vector2.from_angle(angle) * bullet_speed
		bullet.rotation = angle
	return true

func set_vflip(flip: bool):
	$AnimatedSprite2D.flip_v = flip

func _on_body_entered(body):
	if body is Player and ammo != 0 && drop_clock <= 0:
		var player = body as Player
		player.add_grabbable(self)

func _on_body_exited(body):
	if body is Player:
		var player = body as Player
		player.remove_grabbable(self)
