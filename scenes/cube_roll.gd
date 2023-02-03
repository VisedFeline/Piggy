extends AnimatedSprite

signal dice_rolled(roll_score)

var random_generator = RandomNumberGenerator.new()
onready var timer = self.get_node("Timer")
export(float) var spin_interval = 0.1
var FACES_ANIMATION_NAME = "faces"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	random_generator.randomize()
	self.frames.get_frame_count(FACES_ANIMATION_NAME)
	self.frame = random_generator.randi_range(0, self.frames.get_frame_count(FACES_ANIMATION_NAME))
	timer.set_wait_time(spin_interval)
	timer.set_one_shot(false)
	timer.start()


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
	var random_number = random_generator.randi_range(0, self.frames.get_frame_count(FACES_ANIMATION_NAME))
	print(random_number)
	self.frame = random_number


func _on_Timer_timeout():
	set_dice_face()


func _on_Root_new_turn():
	pass
