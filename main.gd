extends Node

# Number of sprites to spawn
const NUM_SPRITES = 20
# Radius of the circle
const RADIUS = 100
# Initial velocity magnitude
const INITIAL_VELOCITY = 400

# Reference to the Sprite scene
@export var sprite_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_sprites()

func spawn_sprites(): 
	# Calcuulate the angle between each sprite
	var angle_step = 360.0 / NUM_SPRITES
	
	for i in range(NUM_SPRITES):
		# Calculate the angle for this sprite
		var angle = i * angle_step
		# Convert angle to radians
		var radians = (i * angle_step * PI) / 180.0
		# Calculate sprite position using polar cooordinates
		var x = RADIUS * cos(radians) + 170
		var y = RADIUS * sin(radians) + 150
		
		# Create a new sprite
		var new_sprite = sprite_scene.instantiate()
		# Set sprite position
		new_sprite.position.x = x
		new_sprite.position.y = y
		
		# Add sprite to the scene
		add_child(new_sprite)
		
		# Calculate velocity vector so they shoot outwards after they spawn
		var velocity = Vector2(x - 170, y - 150).normalized() * INITIAL_VELOCITY
		# Apply velocity to the sprite
		if new_sprite.has_method("set_linear_velocity"):
			new_sprite.set_linear_velocity(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
