extends CharacterBody2D

class_name Player

@export var max_health = 10
var health = 0
@export var speed: float = 300
@export var deadzone: float = 0.3
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5
@export var dash_speed: float = 500
var dash_clock: float = 0
var dash_cooldown_clock: float = 0
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 600
@export var fire_cooldown: float = 0.3
var fire_clock: float = 0
var grab_list: Array[Node2D] = []

func _ready():
	health = max_health

func _physics_process(delta):
	# handle clocks
	if fire_clock > 0:
		fire_clock -= delta
	if dash_clock > 0:
		dash_clock -= delta
	elif dash_cooldown_clock > 0:
		dash_cooldown_clock -= delta
	# handle weapon equipping
	if get_weapon() == null and len(grab_list) > 0:
		set_weapon(grab_list.pop_back())
	var move := get_move()
	if dash_clock > 0:
		$AnimatedSprite2D.frame = 1
		pass
	else:
		velocity = move * speed
		if dash_cooldown_clock > 0:
			$AnimatedSprite2D.frame = 2
		else:
			$AnimatedSprite2D.frame = 0
	var aim := get_aim()
	if aim == Vector2.ZERO:
		aim = move
	if aim.length() > 0:
		$Arm.rotation = aim.angle()
	if Input.is_action_pressed("fire"):
		fire()
	if Input.is_action_pressed("dash"):
		dash()
	if Input.is_action_just_pressed("use") and get_weapon() != null:
		set_weapon(null)
	move_and_slide()
	hud_update()

func get_move() -> Vector2:
	return Input.get_vector("left","right","up","down")

func get_aim() -> Vector2:
	return get_local_mouse_position()

func fire():
	var w = get_weapon()
	if w != null:
		return w.fire()
	if fire_clock > 0:
		return
	fire_clock = fire_cooldown
	var bullet := bullet_scene.instantiate() as Bullet
	get_parent().add_child(bullet)
	bullet.position = $Arm/Hand.global_position
	bullet.velocity = Vector2.from_angle($Arm.rotation) * bullet_speed
	bullet.rotation = $Arm.rotation

func dash():
	if dash_clock > 0:
		return
	if dash_cooldown_clock > 0:
		return
	var move := get_move()
	if move.length() == 0:
		return
	velocity = move * dash_speed
	dash_clock = dash_duration
	dash_cooldown_clock = dash_cooldown

func add_grabbable(weapon: Weapon):
	grab_list.push_back(weapon)
func remove_grabbable(weapon: Weapon):
	grab_list.erase(weapon)
func get_weapon() -> Weapon:
	if $Arm/Hand.get_child_count() == 0:
		return null
	return $Arm/Hand.get_child(0) as Weapon
func set_weapon(weapon: Weapon):
	pass
	# remove previous
	assert($Arm/Hand.get_child_count() <= 1)
	var wep = get_weapon()
	if wep != null:
		var pos = wep.global_position
		var rot = wep.global_rotation
		$Arm/Hand.remove_child(wep)
		get_parent().add_child(wep)
		wep.position = pos
		wep.rotation = rot
		wep.drop_clock = 0.1
	# add
	if weapon == null:
		return
	weapon.get_parent().remove_child(weapon)
	$Arm/Hand.add_child(weapon)
	weapon.position = Vector2.ZERO
	weapon.rotation = 0
func hud_update():
	var line1 = " ".join(["Life:", health, "/", max_health])
	var line2 = "Ammo: -"
	var wep = get_weapon()
	if wep != null:
		line2 = " ".join(["Ammo:", wep.ammo, "/", wep.max_ammo])
	$Camera2D/Hud/Label.text = line1 + "\n" + line2
