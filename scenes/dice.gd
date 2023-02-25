extends KinematicBody2D

signal score_revealed


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation_node = self.get_node("AnimatedSprite")

export(bool) onready var is_rolling = false
onready var velocity = Vector2(0, 0)
export(float) onready var VELOCITY_INCREMENT = 1000
export(float) onready var WALL_DECELERATION = 0.25
export(float) onready var DECELERATION = 0.005
export(float) onready var TERMINAL_VELOCITY = 50
export(int) var THROW_SCREEN_MARGIN = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	""" the die's roll """
	move_die(delta)
	
func move_die(delta):
	""" Implementation of the die roll """
	var collision_info = move_and_collide(self.velocity * delta)
	if collision_info:
		self.velocity = self.velocity.bounce(collision_info.normal)
		self.velocity = self.velocity *  WALL_DECELERATION
		animation_node.rotation = self.velocity.angle() + deg2rad(180)
	if self.velocity.length() >= Vector2(TERMINAL_VELOCITY,TERMINAL_VELOCITY).length():
		self.velocity.x = lerp(self.velocity.x, 0, DECELERATION)
		self.velocity.y = lerp(self.velocity.y, 0, DECELERATION)
	elif self.velocity.length():
		# stop die
		stop_roll()

func geneate_random_position(margin: int=50) -> Vector2:
	""" Generate a random position on the board within the margin """
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_x = rng.randf_range(margin, GlobalVars.SCREEN_SIZE.x - margin)
	var random_y = rng.randf_range(margin, GlobalVars.SCREEN_SIZE.y - margin)
	return Vector2(random_x, random_y)
	
func generate_random_rotation() -> float:
	""" Generate a random rotation degree from 0 to 360 """
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_rotation = deg2rad(rng.randf_range(-360,360))
	return random_rotation
	
	
func initiate_roll(start_position: Vector2, start_rotation: float=0, strength: int=0):
	""" Start the actual roll of the die """
	self.position = start_position
	#self.velocity.rotate = start_rotation
	#self.transform = Transform2D(deg2rad(start_rotation), start_position)
	#self.rotate(deg2rad(start_rotation))
	var roll_velocity = strength * self.VELOCITY_INCREMENT * start_rotation
	self.velocity = Vector2(roll_velocity, roll_velocity)
	

func roll_die(strength: int):
	""" Set the roll of the die from random position with given roll strength """
	var start_position = geneate_random_position(self.THROW_SCREEN_MARGIN)
	var start_rotation = generate_random_rotation()
	self.animation_node.start_roll_animation()
	initiate_roll(start_position, start_rotation, strength)
	
func stop_roll():
	""" Stop the roll of the die by generating score, changing animation and setting frame """
	self.velocity = Vector2(0,0)
	self.animation_node.stop_roll_animation()
	emit_signal("score_revealed", self.animation_node.frame+1)
