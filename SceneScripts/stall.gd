extends StaticBody2D

var hp = 20
var isCustAttacking = false
var isPlayerClose = false

func _ready():
	GlobalVar.connect("attack",self,"_on_attack")
	pass



func _on_Area2D_area_entered(area):
	if area.is_in_group("customers") :
		isCustAttacking = true
	if area.get_name() == "caldo-area":
		isPlayerClose = true
		
func _on_Area2D_area_exited(area):
	if area.is_in_group("customers") :
		isCustAttacking = false
	if area.get_name() == "caldo-area":
		isPlayerClose = false

func _on_attack(atk):
	if isCustAttacking:
		hp -= atk
		print(hp)
		if hp <= 0 :
			hp = clamp (hp,0,20)
			farm_state(true ,hp, Vector2(1,1))
			
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and isPlayerClose and hp < 20:
		if event.scancode == KEY_SPACE:
			print("stall fixed")
			farm_state(false ,20, Vector2(1,2.5))
			
func farm_state(collision,hpset, scaleA):
	hp=hpset
	$CollisionShape2D.set_deferred("disabled", collision)
	$Area2D/Sprite.scale = scaleA


