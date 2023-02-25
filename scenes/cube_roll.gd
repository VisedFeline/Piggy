extends AnimatedSprite

signal dice_rolled(roll_score)

var random_generator = RandomNumberGenerator.new()
onready var timer = self.get_node("Timer")
export(float) var spin_interval = 0.1
var FACES_ANIMATION_NAME = "faces"
var ROLL_ANIMATION_NAME = "roll"
export(int) var THROW_SCREEN_MARGIN = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = FACES_ANIMATION_NAME
	random_generator.randomize()
	self.frame = random_generator.randi_range(0, self.frames.get_frame_count(FACES_ANIMATION_NAME))
	#timer.set_wait_time(spin_interval)
	#timer.set_one_shot(false)
	#timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("roll_dice"):
#		if timer.is_stopped():
#			print("started")
#			timer.start()
#		elif not timer.is_stopped():
#			print("stopped")
#			timer.stop()
#			var current_roll = self.frame + 1
#			emit_signal("dice_rolled", current_roll)


func roll_dice():
	if timer.is_stopped():
		print("started")
		timer.start()
	elif not timer.is_stopped():
		print("stopped")
		timer.stop()
		var current_roll = self.frame + 1
		emit_signal("dice_rolled", current_roll)


func set_dice_face():
	self.animation = FACES_ANIMATION_NAME
	var random_number = random_generator.randi_range(0, self.frames.get_frame_count(FACES_ANIMATION_NAME))
	print(random_number)
	self.frame = random_number


func _on_Timer_timeout():
	set_dice_face()


func _on_Root_new_turn():
	pass
	
	
func geneate_random_position(margin: int=50) -> Vector2:
	""" Generate a random position on the board within the margin """
	var rng = RandomNumberGenerator.new()
	var random_x = rng.randf_range(margin, GlobalVars.SCREEN_SIZE.x)
	var random_y = rng.randf_range(margin, GlobalVars.SCREEN_SIZE.y)
	return Vector2()
	
func start_roll_animation():
	""" Start the die roll animation """
	self.play(self.ROLL_ANIMATION_NAME)
	
func initiate_roll(position: Vector2, strength: int=0):
	""" Start the actual roll of the die """
	self.translate(position)
	

func roll_die(strength: int):
	""" Set the roll of the die from random position with given roll strength """
	position = geneate_random_position(self.THROW_SCREEN_MARGIN)
	start_roll_animation()
	initiate_roll(position, strength)
	
func stop_roll_animation():
	""" Stop the roll of the die by generating score, changing animation and setting frame """
	self.stop()
	self.set_dice_face()
