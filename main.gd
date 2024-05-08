extends Node

# Number of sprites to spawn
const NUM_SPRITES = 12
# Radius of the circle
const RADIUS = 100
# Initial velocity magnitude
const INITIAL_VELOCITY = 300


# Reference to the Sprite scene
@export var sprite_scene : PackedScene
const NINJA = preload("res://scenes/character/ninja/ninja.tscn")
const KNIGHT = preload("res://scenes/character/knight/knight.tscn")
const MAX_NUMBER = 2

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
		var x = RADIUS * cos(radians) + 320
		var y = RADIUS * sin(radians) + 320
		
		# Randomly create a sprite
		var chosen_number = randi() % MAX_NUMBER
		var new_sprite
		if chosen_number == 1:
			new_sprite = KNIGHT.instantiate()
		if chosen_number == 0:
			new_sprite = NINJA.instantiate()
		# Set sprite position
		new_sprite.position.x = x
		new_sprite.position.y = y
		
		# Add sprite to the scene
		add_child(new_sprite)
		
		# Calculate velocity vector so they shoot outwards after they spawn
		var velocity = Vector2(x - 320, y - 320).normalized() * new_sprite.INITIAL_VELOCITY
		# Apply velocity to the sprite
		if new_sprite.has_method("set_linear_velocity"):
			new_sprite.set_linear_velocity(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
