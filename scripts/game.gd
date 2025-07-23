extends Node

@onready var bet_label = $"CenterContainer/VMainBoxContainer/CenterContainer/TopBar(HBox)/BetBox(HBox)/BetLabel"
@onready var info_text = $"CenterContainer/VMainBoxContainer/CenterContainer/TopBar(HBox)/InfoText"

@onready var red_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/RedButton"
@onready var black_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/BlackButton"
@onready var higher_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/HigherButton"
@onready var lower_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/LowerButton"
@onready var between_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/BetweenButton"
@onready var outside_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/OutSideButton"
@onready var hearts_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/HeartsButton"
@onready var diamonds_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/DiamondsButton"
@onready var clubs_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/ClubsButton"
@onready var spades_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/SpadesButton"
@onready var stand_button = $"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/StandButton"
@onready var restart_big_button = $CenterContainer/VMainBoxContainer/RestartButton

@onready var popup_wrong_guess = $PopUpWrongGuess
@onready var popup_label = $PopUpWrongGuess/VBoxContainer/PopUpLabel
@onready var restart_button = $PopUpWrongGuess/VBoxContainer/ResetButton
@onready var popup_challenge = $PopUpChallenge
@onready var popup_challenge_label =$PopUpChallenge/VBoxContainer/PopUpChallengeLabel
@onready var restart_challenge_button = $PopUpChallenge/VBoxContainer/ResetChallengeButton
@onready var popup_stand = $PopUpStand
@onready var pop_standlabel = $PopUpStand/VBoxContainer/StandLabel
@onready var reset_stand_button = $PopUpStand/VBoxContainer/ResetStandButton
@onready var popup_won = $PopUpWon
@onready var popup_won_label = $PopUpWon/VBoxContainer/WonLabel
@onready var reset_won_button = $PopUpWon/VBoxContainer/RestartGameButton

signal request_reset_to_bet


var player_bet = 0
var first_draw := true
var nr_guess :=0
const SPECIAL_CARD_CHANCE := 0.05

var first_card : CardData
var second_card : CardData
var third_card : CardData

var higher_card : CardData
var lower_card : CardData

func set_bet(bet: int):
	player_bet = bet
	bet_label.text = "Sips: %d" % bet
	red_button.visible=true
	black_button.visible=true
	first_draw = true
	info_text.text = "Red or Black?"
	build_deck()
	deck.shuffle()

var deck: Array[CardData] = []
var challenge_deck: Array[String] = [
	"The oldest player drinks 6 sips.",
	"Whisper a word to your left. Each player passes it along. If the last player repeats it correctly, you drink 8 sips. If not, everyone else drinks 4 sips.",
	"Pick a category (e.g. car brands). Players take turns naming something in tha category. The first one who can't think of anything drinks 4 sips.",
	"Raise your hand. The last player to do so drinks 4 sips.",
	"Sing a short song. The first to guess it correctly gives out 8 sips.",
	"The youngest player drinks 6 sips.",
	"Pick a number between 1 and 9. Starting with you, count upwards. If a number matches your choice (by being the number itself, a multiple, sum of digits, etc.), the player must clap instead of saying it. First mistake drinks 10 sips."
]

func build_deck():
	for suit in CardData.Suit.values():
		for rank in range(2,15):
			deck.append(CardData.new(suit, rank))


func _ready():
	build_deck()
	deck.shuffle()

func audio_flipcard():
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/CardDrawPlayer".stop()
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/ChoicesBox(VBox)/CardDrawPlayer".play()

func _on_red_button_pressed():
	handle_guess("red")
	audio_flipcard()
func _on_black_button_pressed():
	handle_guess("black")
	audio_flipcard()

func _on_higher_button_pressed():
	handle_higher_lower("higher")
	audio_flipcard()
func _on_lower_button_pressed():
	handle_higher_lower("lower")
	audio_flipcard()

func _on_between_button_pressed():
	handle_between_outside("between")
	audio_flipcard()
func _on_outside_button_pressed():
	handle_between_outside("outside")
	audio_flipcard()

func _on_hearts_button_pressed():
	handle_suits("hearts")
	audio_flipcard()
func _on_diamonds_button_pressed():
	handle_suits("diamonds")
	audio_flipcard()
func _on_clubs_button_pressed():
	handle_suits("clubs")
	audio_flipcard()
func _on_spades_button_pressed():
	handle_suits("spades")
	audio_flipcard()

func _on_stand_button_pressed():
	handle_stand_button()

func _on_RestartButton_pressed():
	deck.clear()
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card1".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card2".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card3".texture = null
	bet_label.text =""
	info_text.text=""
	nr_guess=0
	update_ui_for_guess_stage()
	player_bet=0
	popup_wrong_guess.hide()
	request_reset_to_bet.emit()
func _on_Reset_Stand_button_pressed():
	deck.clear()
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card1".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card2".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card3".texture = null
	bet_label.text =""
	info_text.text=""
	nr_guess=0
	update_ui_for_guess_stage()
	player_bet=0
	popup_stand.hide()
	request_reset_to_bet.emit()
func _on_RestartChallengeButton_pressed():
	print("Restart button pressed")
	deck.clear()
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card1".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card2".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card3".texture = null
	bet_label.text =""
	info_text.text=""
	nr_guess=0
	update_ui_for_guess_stage()
	player_bet=0
	popup_challenge.hide()
	request_reset_to_bet.emit()
func _on_restart_big_button_pressed():
	print("Restart button pressed")
	deck.clear()
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card1".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card2".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card3".texture = null
	bet_label.text =""
	info_text.text=""
	nr_guess=0
	update_ui_for_guess_stage()
	player_bet=0
	popup_wrong_guess.hide()
	request_reset_to_bet.emit()
func _on_reset_won_button_pressed():
	deck.clear()
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card1".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card2".texture = null
	$"CenterContainer/VMainBoxContainer/CardRow(HBox)/Card3".texture = null
	bet_label.text =""
	info_text.text=""
	nr_guess=0
	update_ui_for_guess_stage()
	player_bet=0
	popup_won.hide()
	request_reset_to_bet.emit()

func update_ui_for_guess_stage():
	# Hide all buttons by default
	var all_buttons = [
		red_button, black_button,
		higher_button, lower_button,
		between_button, outside_button,
		hearts_button, diamonds_button,
		clubs_button, spades_button,
		stand_button
	]
	for btn in all_buttons:
		btn.visible = false

	# Show only the relevant buttons based on the round
	match nr_guess:
		0:
			red_button.visible = true
			black_button.visible = true
		1:
			higher_button.visible = true
			lower_button.visible = true
			stand_button.visible = true
		2:
			between_button.visible = true
			outside_button.visible = true
			stand_button.visible = true
		3:
			hearts_button.visible = true
			diamonds_button.visible = true
			clubs_button.visible = true
			spades_button.visible = true
			stand_button.visible = true

func handle_guess(choice: String):
	red_button.visible=false
	black_button.visible=false
	if first_draw and randf() < SPECIAL_CARD_CHANCE:
		trigger_special_card()
	else:
		draw_card_red_black(choice)
		first_draw=false

func handle_higher_lower(choice: String):
	if deck.is_empty():
		info_text.text = "No more cards!"
		return
	
	show_old_card(first_card,1)
	var card = deck.pop_back()
	show_card(card)
	
	if card.rank==first_card.rank:
		trigger_special_card()
		return
	
	var correct = ((choice == "lower" and card.rank<first_card.rank) or
	(choice == "higher" and card.rank>first_card.rank))
	
	if correct:
		if choice == "higher":
			higher_card = card
			lower_card = first_card
		elif choice == "lower":
			lower_card = card
			higher_card = first_card
		else:
			if choice == "higher":
				higher_card = first_card
				lower_card = card
			elif choice == "lower":
				higher_card = card
				lower_card = first_card
	
	if correct:
		player_bet *=1.5
		bet_label.text = "Sips : %d" %player_bet
		info_text.text = "Between or Outside?"
		second_card = card
		nr_guess +=1
		update_ui_for_guess_stage()
		
	else:
		higher_button.visible = false
		lower_button.visible = false
		stand_button.visible = false
		popup_label.text = "Wrong! You owe %d Sips" %player_bet
		popup_wrong_guess.popup_centered(Vector2(200,100))

func handle_between_outside(choice: String):
	if deck.is_empty():
		info_text.text = "No more cards!"
		return
	
	show_old_card(second_card,2)
	var card = deck.pop_back()
	show_card(card)
	
	if card.rank == higher_card.rank or card.rank == lower_card.rank:
		trigger_special_card()
		return
	
	var correct = ((choice == "outside" and (lower_card.rank>card.rank or higher_card.rank<card.rank)) or
	(choice == "between" and (card.rank > lower_card.rank and card.rank < higher_card.rank)))
	
	if correct:
		player_bet *=1.5
		bet_label.text = "Sips : %d" %player_bet
		third_card = card
		info_text.text = "Which suit is the card?"
		nr_guess +=1
		update_ui_for_guess_stage()
	else:
		between_button.visible = false
		outside_button.visible = false
		stand_button.visible = false
		popup_label.text = "Wrong! You owe %d Sips" %player_bet
		popup_wrong_guess.popup_centered(Vector2(200,100))

func handle_suits(choice: String):
	if deck.is_empty():
		info_text.text = "No more cards!"
		return
	show_old_card(third_card, 3)
	var card = deck.pop_back()
	show_card(card)
	var suit_match = {
		"hearts": 0,
		"diamonds": 1,
		"clubs": 2,
		"spades": 3,
	}
	print(choice)
	var correct = suit_match.has(choice) and card.suit == suit_match[choice]
	
	if correct:
		player_bet *= 1.5
		bet_label.text = "Sips: %d" % player_bet
		nr_guess += 1
		update_ui_for_guess_stage()
		popup_won_label.text = "Distribute %d Sips" % player_bet
		popup_won.popup_centered(Vector2(200, 100))
	else:
		# Hide all suit buttons
		for b in [hearts_button, diamonds_button, spades_button, clubs_button]:
			b.visible = false
		stand_button.visible = false
		popup_label.text = "Wrong! You owe %d Sips" % player_bet
		popup_wrong_guess.popup_centered(Vector2(200, 100))

func trigger_special_card():#POPUP in future
	#$"VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".texture = null
	#$"VMainBoxContainer/CardRow(HBox)/Card1".texture = null
	#$"VMainBoxContainer/CardRow(HBox)/Card2".texture = null
	#$"VMainBoxContainer/CardRow(HBox)/Card3".texture = null
	nr_guess = -1
	update_ui_for_guess_stage()
	var challenge = challenge_deck.pick_random()
	#info_text.text="Special Card! : \n"+challenge
	#bet_label.text = "You owe %d Drinks" %player_bet
	popup_challenge_label.text ="Challenge: \n"+challenge
	popup_challenge.popup_centered(Vector2(225,125))


func draw_card_red_black(choice: String):
	if deck.is_empty():
		info_text.text = "No more cards!"
		return
	
	var card = deck.pop_back()
	show_card(card)
	
	var result =  (card.color==choice)
	if result:
		player_bet *=1.5
		bet_label.text = "Sips : %d" %player_bet
		info_text.text = "Higher or Lower?"
		first_card = card
		nr_guess +=1
		update_ui_for_guess_stage()
	else:
		#popup you lose -> replay button
		red_button.visible = false
		black_button.visible = false
		popup_label.text = "Wrong! You owe %d Sips" %player_bet
		popup_wrong_guess.popup_centered(Vector2(200,100))

func handle_stand_button():
	nr_guess=-1
	update_ui_for_guess_stage()
	pop_standlabel.text = "Distribute %d Sips" %player_bet
	popup_stand.popup_centered(Vector2(200,100))

func show_card(card: CardData):
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".scale = Vector2(0.5,0.5)
	$"CenterContainer/VMainBoxContainer/GameArea(HBox)/CurrentCardSprite".texture = get_card_texture(card)

func show_old_card(card: CardData, index:int):
	var path = "CenterContainer/VMainBoxContainer/CardRow(HBox)/Card%d" % index
	var sprite_node = get_node(path)
	sprite_node.scale = Vector2(0.15,0.15)
	sprite_node.texture =get_card_texture(card)

func get_card_texture (card:CardData) ->Texture:
	var rank_lookup = {
		14: "ace",
		11: "jack",
		12: "queen",
		13: "king"
	}
	var rank_str = rank_lookup.get(card.rank, str(card.rank))  # fallback to number string
	var suit_str = CardData.Suit.keys()[card.suit].to_lower()
	var path = "res://assets/PNG-cards-1.3/%s_of_%s.png" % [rank_str, suit_str]
	return load(path)
	
