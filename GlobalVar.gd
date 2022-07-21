extends Node

var player_holding = []
var player_dish_holding = null

func _ready():
	set_process(false)
	pass

func _process(_delta):
	print(player_holding)
