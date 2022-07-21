extends Node

var player_holding = []

func _ready():
	set_process(true)
	pass

func _process(_delta):
	print(player_holding)
