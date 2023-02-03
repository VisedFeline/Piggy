extends Label

signal victory()

onready var score = 0

export(int) var player_index = 1
export(bool) var is_current_player = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "PLAYER {player_index}     {score}".format({"player_index": player_index, "score": score})
	
	if self.is_current_player:
		get_node("player_index").visible = true
	else:
		get_node("player_index").visible = false
	
