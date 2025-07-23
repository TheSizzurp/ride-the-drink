# File: res://scripts/CardData.gd

class_name CardData
extends Object

enum Suit { Hearts, Diamonds, Clubs, Spades }

var suit: Suit
var rank: int
var color: String

func _init(s: Suit, r: int) -> void:
	suit = s
	rank = r
	color = "red" if suit == Suit.Hearts or suit == Suit.Diamonds else "black"

func duplicate() -> CardData:
	return CardData.new(suit, rank)
