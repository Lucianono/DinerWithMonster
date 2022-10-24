extends KinematicBody2D

var kboard = Vector2(0,0)
var screensize
var sprite_extent
export var speed = 120

onready var anim_tree = get_node("caldo-area/AnimationTree")
onready var anim_state = anim_tree.get("parameters/playback")

func _ready():
	sprite_extent = Vector2(16,25)
	screensize = get_viewport_rect().size
	set_physics_process(true)
	
	
func _physics_process(_delta):
	# when keyboard pressed
	kboard.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	kboard.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	if kboard != Vector2.ZERO:
		anim_state.travel("walk")
		anim_tree.set("parameters/walk/blend_position",kboard)
		if kboard.x != 0 :
			get_node("caldo-area/Sprite").scale.x = kboard.x
	else :
		anim_state.travel("idleRight")
	
	kboard = kboard.normalized() * speed
	kboard = move_and_slide(kboard)
	
	
	#limits caldo position
	position.y = clamp(position.y, 1 + sprite_extent.y, screensize.y - sprite_extent.y)
	position.x = clamp(position.x, 1 + sprite_extent.x, get_node("/root/Node2D/StallNodes").position.x - sprite_extent.x)
	
	
	
	
	
	
	
