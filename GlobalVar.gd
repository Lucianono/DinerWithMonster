extends Node

var player_holding = []
var player_dish_holding = null
var isPlayerCooking = false

func _ready():
	set_process(true)
	pass

func _process(_delta):
	print(player_holding)
