extends Node2D

signal new_turn()

onready var cube = self.get_node("Cube")
#onready var player_one = self.get_node("player_one")
#onready var player_two = self.get_node("player_two")
onready var players = []
onready var current_player_index = 0
onready var current_player = null
export(int) onready var current_score = 0
export(int) onready var winner_index = null
export(int) onready var players_amount = 1
export(int) onready var player_y_position = 30

# FIGURE OUT HOW TO GET FROM NODE
export(int) onready var player_x_size = 40
export(int) onready var player_y_size = 140

export(int) onready var margin_from_screen = 30
# export(int) onready var base_players_margin = 500
var player_scene = preload("res://scenes/Player.tscn")
var WINNER_SCENE = "res://scenes/WinnerScene.tscn"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	create_players(self.players_amount)
	set_player_indices()
	set_first_player()
	var current_player = players[current_player_index]
	current_player.is_current_player = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("roll_dice"):
		cube.roll_die(1)


	if Input.is_action_just_pressed("end_turn"):
		end_turn()
		#cube.timer.start()


func create_players(players_amount: int):
	""" Create players_amount player objects """
	var screen_width = GlobalVars.SCREEN_SIZE.x
	var base_players_margin = screen_width - 2 * self.margin_from_screen
	var current_x_position = self.margin_from_screen
	var total_player_space = base_players_margin / self.players_amount
	# var player_width = total_player_space * (2/3)
	# var player_margin = base_players_margin / self.players_amount
	print("width " + str(screen_width))
	for i in range(self.players_amount):
		var new_player = self.player_scene.instance()
		var player_position = Vector2(current_x_position, self.player_y_position)
		new_player.set_position(player_position)
		print("rs: " + str(current_x_position))
		# var player_size = Vector2(player_width, self.player_y_size) # figure out weird size setting
		current_x_position += total_player_space
		# new_player.rect_size = player_size
		add_child(new_player)
		self.players.append(new_player)

func set_player_indices():
	""" Set the index attribute of each player, needs to change to start from 0 instead of 1 """
	var current_index = 1
	for player in players:
		player.player_index = current_index
		current_index += 1
		
func set_first_player():
	current_player = players[current_player_index]
	self.players[0].is_current_player = true

func sleep(seconds):
	yield(get_tree().create_timer(seconds), "timeout")


func _on_AnimatedSprite_dice_rolled(roll_score):
	""" Handle dice roll """
	if roll_score == 1:
		current_score = 0
		end_turn()
	else:
		current_score += roll_score
		print("current score is", current_score)
	


func end_turn():
	""" Finish a player's turn by adding points, checking for winner and moving the turn to next player"""
	print("added ", current_score, " points to player", current_player_index)
	current_player.update_score(current_score)
	current_score = 0
	
	if current_player.score >= GlobalVars.TARGET_SCORE:
		winner_index = current_player_index
		end_game(winner_index)
	

	current_player.is_current_player = false
	current_player_index = (current_player_index+1) % len(players)
	current_player = players[current_player_index]
	current_player.is_current_player = true
	

func end_game(winner_index):
	print("PLAYER {winner_index} WINS!!1".format({"winner_index": winner_index+1}))
	GlobalVars.WINNER_INDEX = winner_index
	get_tree().change_scene(WINNER_SCENE)
	

# func _on_player_one_victory():
#	print("PLAYER 1 WINS")


# func _on_player_two_victory():
#	print("PLAYER 2 WINS")


func _on_Cube_score_revealed(score):
	if score == 1:
		self.current_score = 0
		end_turn()
	else:
		self.current_score += score
		print("current score is ", current_score)
	#print("added ", self.current_score, " points to player ", score)
	#self.current_score += score
