extends Control
@onready var start_screen = $StartingGame
@onready var bet_screen = $Betting
@onready var game_scene = $Game

func _ready():
	start_screen.visible = true
	bet_screen.visible = false
	game_scene.visible = false
	game_scene.request_reset_to_bet.connect(_reset_to_bet)
	start_screen.connect("start_game", _on_start_game)
	bet_screen.connect("bet_confirmed", _on_bet_confirmed)

func _on_start_game():
	start_screen.visible = false
	bet_screen.visible = true

func _on_bet_confirmed(bet: int):
	bet_screen.visible = false
	game_scene.visible = true
	game_scene.set_bet(bet)

func _reset_to_bet():
	game_scene.visible = false
	bet_screen.visible = true
