extends StaticBody2D

var hp = 20
var isCustAttacking = false
var isPlayerClose = false
onready var health_bar = $ProgressBar

func _ready():
	health_bar.visible = false
	var _x = GlobalVar.connect("attack",self,"_on_attack")
	health_bar.value = hp
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

#atk signal from customers
func _on_attack(atk):
	if isCustAttacking and hp>0:
		health_bar.visible = true
		hp -= atk
		if hp <= 0 :
			hp=0
			print(hp)
			farm_state(true ,hp, Vector2(1,1))
		health_bar.value = hp
	
#spacebar to fix		
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and isPlayerClose and hp < 20  and GlobalVar.total_repair_points >= (20-hp):
		if event.scancode == KEY_SPACE:
			print(get_name()," fixed")
			GlobalVar.repair_farm(20, hp)
			farm_state(false ,20, Vector2(1,2.5))
			health_bar.visible = false

#to change farm state	
func farm_state(collision,hpset, scaleA):
	hp=hpset
	health_bar.value = hp
	$CollisionShape2D.set_deferred("disabled", collision)
	$Area2D/Sprite.scale = scaleA



