extends Label

signal victory()

onready var score = 0

export(int) var player_index = 1
export(bool) var is_current_player = false
onready var fill_thresholds = {}

onready var fill_meter = self.get_node("fill_meter")
onready var fill_meter_animation = "piggy_fill"

# Called when the node enters the scene tree for the first time.
func _ready():
	self._set_meter()
	self.update_score(self.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if self.is_current_player:
		get_node("player_index").visible = true
	else:
		get_node("player_index").visible = false
		

func _set_meter():
	""" Set the threshold to frame dictionary """
	var sprites_amount = self.fill_meter.frames.get_frame_count(fill_meter_animation)
	var threshold_increment = GlobalVars.TARGET_SCORE / sprites_amount
	var current_threshold = 0
	
	for index in range(sprites_amount):
		current_threshold = index * threshold_increment
		self.fill_thresholds[current_threshold] = index
		

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
	
	
	
