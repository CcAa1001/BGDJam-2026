extends Node

signal score(new_score)
var current_score: int =0

# Called when the node enters the scene tree for the first time.
func add_score(amount: int):
	current_score += amount
	score.emit(current_score)
