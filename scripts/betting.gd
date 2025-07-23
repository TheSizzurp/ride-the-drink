extends Control
signal bet_confirmed(bet: int)

func _on_ConfirmBetButton_pressed():
	var bet = $CenterContainer/VBoxContainer/BetInput.text.to_int()
	if bet >= 1 and bet <= 20:
		emit_signal("bet_confirmed", bet)
		$CenterContainer/VBoxContainer/ChipBettingAudio.play()
	
	else:
		$CenterContainer/VBoxContainer/BetLabel.text = "Enter a number between 1 and 20"
