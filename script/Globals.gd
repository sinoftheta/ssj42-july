extends Node

var bullet_pool: Pool

func _ready():
	bullet_pool = Pool.new()
	bullet_pool.scene = load("res://entities/Bullet.tscn")
