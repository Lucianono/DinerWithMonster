extends StaticBody2D


func _ready():
	pass


func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		print(area.get_name())
