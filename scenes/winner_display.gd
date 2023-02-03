extends TextureRect

onready var winner_label = self.get_node("winner_label")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var winner_index = 0
	print(str(GlobalVars.WINNER_INDEX))
	winner_label.text = "CONGRATULATIONS!!!!\nTHE WINNDER IS PLAYER {winner_index}".format({"winner_index": winner_index+1})


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
