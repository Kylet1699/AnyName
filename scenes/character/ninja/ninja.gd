extends RigidBody2D

@onready var sprite_2d = $ninja_sprite
@onready var animation_player = $AnimationPlayer
@onready var health_bar = $health_bar
@onready var main = get_tree().get_root().get_node("Main")
@onready var sai = preload("res://scenes/projectiles/sai.tscn")
@onready var collision_shape_2d = $CollisionShape2D

var max_health = 100.0
var curr_health = max_health
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var attack_damage = 10.0
var special_attack_damage = 30.0
var special_attack_cd_duration = 3.0
var special_attack_cd_timer = special_attack_cd_duration
var next_attack = attack_damage
var INITIAL_VELOCITY = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the cooldown timer
	special_attack_cd_timer = max(0, special_attack_cd_timer - delta)
	if special_attack_cd_timer <= 0:
		sprite_2d.play("special")
		shoot()
		special_attack_cd_timer = special_attack_cd_duration
	
	# Check the velocity
	velocity = get_linear_velocity()
	
	# Determine the direction of movement
	if velocity.x != 0:
		direction.x = sign(velocity.x)
	if velocity.y != 0:
		direction.y = sign(velocity.y)

	if curr_health == 0:
		return
		
	# Play different animations based on the direction
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0:
			sprite_2d.play("left")
		else:
			sprite_2d.play("right")
	else:
		if velocity.y < 0:
			sprite_2d.play("up")
		else:
			sprite_2d.play("down")
	pass


func _on_body_entered(body):
	if (body.is_in_group("characters") or body.is_in_group("projectiles")):
		# Play different animations based on the direction
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x < 0:
				sprite_2d.play("attack_left")
			else:
				sprite_2d.play("attack_right")
		else:
			if velocity.y < 0:
				sprite_2d.play("attack_up")
			else:
				sprite_2d.play("attack_down")
			
		take_damage(body.next_attack)
		
func take_damage(amount) -> void:
	animation_player.play("hit")
	
	curr_health -= amount
	health_bar.value = curr_health
	
	if curr_health <= 0:
		curr_health = 0
		set_linear_velocity(Vector2(0, 0))
		sprite_2d.play("defeat")
		await get_tree().create_timer(1.0).timeout
		queue_free()

	if curr_health > 0:
		var health_percent = 1.0 - curr_health / max_health
		
		var size_scale = 1.3 * (health_percent + 1)
		sprite_2d.scale.x = size_scale
		sprite_2d.scale.y = size_scale
		collision_shape_2d.scale.x = size_scale
		collision_shape_2d.scale.y = size_scale

func shoot():
	var instance = sai.instantiate()

	# some bugs with the projectile direction, not shooting towards the correct direction
	velocity = get_linear_velocity()
	instance.dir = rad_to_deg(velocity.angle())

	instance.spawn_position = global_position
	instance.spawn_rotation = global_rotation
	instance.projectile_owner = self
	instance.next_attack = special_attack_damage
	main.add_child.call_deferred(instance)
