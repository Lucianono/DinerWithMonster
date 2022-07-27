extends StaticBody2D

var hp = 20
var isCustAttacking = false

func _ready():
	GlobalVar.connect("attack",self,"_on_attack")
	pass



func _on_Area2D_area_entered(area):
	if area.is_in_group("customers") :
		isCustAttacking = true
		pass

func _on_Area2D_area_exited(area):
	if area.is_in_group("customers") :
		isCustAttacking = false
		pass

func _on_attack(atk):
	if isCustAttacking:
		hp -= atk
		print(hp)
		if hp <= 0 :
			queue_free()
			set_deferred("disabled", true)


