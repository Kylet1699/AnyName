extends CharacterBody2D

@export var SPEED = 200

var dir : float
var spawn_position : Vector2
var spawn_rotation : float
var projectile_owner : RigidBody2D
var next_attack : float


func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation
	
func _physics_process(delta): 
	velocity = Vector2(0, -SPEED).rotated(dir)
	self.rotation = dir
	move_and_slide()


func _on_area_2d_body_entered(body):
	# If in contact with the map, destroy the projectile
	if body.name == "TileMap":
		queue_free()
	
	# If in contact with character and it's not the owner, destroy the projectile
	if body.is_in_group("characters") and projectile_owner != body:
		print("HIT")
		queue_free()

#
#func _on_life_timeout():
	#queue_free()
