extends Area2D


func _ready():
	pass


func _on_ingredientdrop_area_entered(area):
	if area.get_name() == "caldo-area" :
		print("wow")
		queue_free()
