extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var cube = self.get_node("/root/Root/Cube")

export(Vector2) var INITIAL_POSITION = self.position
export(Vector2) var initial_velocity = Vector2()
export(float) var ZOOM_IN_VELOCITY = 0.1
export(Vector2) var INITIAL_ZOOM = self.zoom
export(Vector2) var TERMINAL_ZOOM = Vector2(0.5, 0.5)
export(float) var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if initial_velocity.length():
		print(cube.velocity.length() / initial_velocity.length())
	if initial_velocity.length() and cube.velocity.length() / initial_velocity.length() < ZOOM_IN_VELOCITY:
		self.position = cube.position
		time_elapsed += delta
		self.zoom = self.zoom.linear_interpolate(TERMINAL_ZOOM, delta)


func _on_Cube_start_rolling(velocity):
	initial_velocity = velocity


func _on_Cube_score_revealed(yap):
	print("shiiiii")
	initial_velocity = Vector2()
	self.position = INITIAL_POSITION
	self.zoom = INITIAL_ZOOM
