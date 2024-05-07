extends RigidBody2D

@onready var sprite_2d = $Sprite2D

var health = 100
var attack_damage = 20
var velocity
var special_attack_damage = 80
var special_attack_cd_timer = 2
var special_attack_cd_duration = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the cooldown timer
	special_attack_cd_timer = max(0, special_attack_cd_timer - delta)
	
	# Check the velocity
	velocity = get_linear_velocity()
	if (self.name == "RigidBody2D"):
		print(velocity)
	
	# Determine the direction of movement
	var direction = Vector2.ZERO
	if velocity.x != 0:
		direction.x = sign(velocity.x)
	if velocity.y != 0:
		direction.y = sign(velocity.y)

	# Play different animations based on the direction
	if direction.x == 1:
		sprite_2d.play("right")
	elif direction.x == -1:
		sprite_2d.play("left")
	elif direction.y == 1:
		sprite_2d.play("down")
	elif direction.y == -1:
		sprite_2d.play("up")
	else:
		sprite_2d.play("idle")
	pass


func _on_body_entered(body):
	pass
	## Check if colliding body is another RigidBody2D
	#if body is RigidBody2D:
		#
		## Get the normal vector of the collision
		#var normal = collision.normal
		#
		## Get the current linear velocity
		#var velocity = get_linear_velocity()
		#
		## Scale the velocity vector to add speed in the direction of the collision normal
		#velocity += normal * body.attack_damage
		#
		## Set the new velocity
		#set_linear_velocity(velocity)
		#print("Collided with ", body.velocity)
		
func _on_body_exited(body):
	if (self.name == "RigidBody2D"):
		print("old velocity: ", self.velocity, "collided with ", body.name)
		
	if (body is RigidBody2D):
		var dmg_taken
		if (body.special_attack_cd_timer == 0):
			print("hit by special")
			dmg_taken = Vector2(self.velocity.x, self.velocity.y).normalized() * body.special_attack_damage
			body.special_attack_cd_timer = body.special_attack_cd_duration
		else:
			dmg_taken = Vector2(self.velocity.x, self.velocity.y).normalized() * body.attack_damage
		set_linear_velocity(Vector2(self.velocity.x + dmg_taken.x, self.velocity.y + dmg_taken.y))
		
	if (self.name == "RigidBody2D"):
		print("new velocity: ", self.velocity)
