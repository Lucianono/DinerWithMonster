extends Area2D


func _ready():
	pass


func _on_Stallarea_area_entered(area):
	if area.get_name() == "Caldo-player":
		print("klang")

