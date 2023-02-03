extends Label

onready var root = get_tree().get_root().get_node("Root")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "CURRENT SCORE: {current_score}".format({"current_score": str(root.current_score)})
