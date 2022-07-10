extends Node

onready var caldo_sprite = preload("res://main-sprite.tscn")

func _ready():
	add_child(caldo_sprite.instance())
