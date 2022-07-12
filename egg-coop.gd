extends StaticBody2D

signal coop_entered

func _ready():
	pass


func _on_Area2D_area_entered(area):
	if(area.get_name() == "caldo-area"):
		emit_signal("coop_entered")
		
		print(area.get_name())
