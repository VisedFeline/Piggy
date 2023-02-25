extends Label

signal victory()

onready var score = 0

export(int) var player_index = 1
export(bool) var is_current_player = false
onready var fill_thresholds = {}

onready var player_index_node = self.get_node("player_index")

onready var fill_meter = self.get_node("fill_meter")
onready var fill_meter_animation = "piggy_fill"

onready var strength_meter = self.get_node("strength_meter")
onready var strength_meter_animation = "strength_meter"
export(float) onready var strength = 0.0 setget set_strength
onready var strength_thresholds = {}
export(float) onready var MAX_STRENGTH = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	self._set_meter()
	self._set_strength_thresholds()
	self.update_score(self.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if self.is_current_player:
		player_index_node.visible = true
	else:
		player_index_node.visible = false
		strength_meter.visible = false
		

func _set_meter():
	""" Set the threshold to frame dictionary """
	var sprites_amount = self.fill_meter.frames.get_frame_count(fill_meter_animation)
	var threshold_increment = GlobalVars.TARGET_SCORE / sprites_amount
	var current_threshold = 0
	
	for index in range(sprites_amount):
		current_threshold = index * threshold_increment
		self.fill_thresholds[current_threshold] = index
		
func _set_strength_thresholds():
	""" Set the threshold to strength dictionary """
	var sprites_amount = self.strength_meter.frames.get_frame_count(strength_meter_animation)
	var threshold_increment = MAX_STRENGTH / sprites_amount
	var current_threshold = 0
	
	for index in range(sprites_amount):
		current_threshold = index * threshold_increment
		self.strength_thresholds[current_threshold] = index
		

func _update_meter_sprite():
	""" Update the sprite of the piggy meter """
	var thresholds = self.fill_thresholds.keys()
	thresholds.sort()
	thresholds.invert()
	print("thres: " + str(thresholds))
	print("mama: " + str(self.fill_thresholds))
	for threshold in thresholds:
		if self.score > threshold:
			print("sc " + str(self.score))
			print("threshold " + str(threshold))
			self.fill_meter.frame = self.fill_thresholds[threshold]
			break

func update_score(points: int):
	""" Add points to score and handle score related events S"""
	self.score += points
	self.text = "PLAYER {player_index}     {score}".format({"player_index": player_index, "score": score})
	self._update_meter_sprite()
	
func set_strength(new_strength: float):
	""" Set the strength to strength and set animation frame """
	strength = new_strength
	strength_meter.visible = bool(strength)
	self.strength_meter.frame = self.strength_thresholds[int(strength)]
	
