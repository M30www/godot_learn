extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
# 尝试添加一个二段跳功能，通过空中和落地程维护个bool值来实现
var CAN_DOUBLE_JUMP := true
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# 在地上恢复二段跳状态
	if is_on_floor():
		CAN_DOUBLE_JUMP = true
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and CAN_DOUBLE_JUMP:
		# 播放跳跃音效
		jump_sound.play()
		velocity.y = JUMP_VELOCITY
		# 当不在地面使用跳跃的时候消耗跳跃次数（两次使用bool，多次可能需要维护一个int值..?
		if !is_on_floor():
			CAN_DOUBLE_JUMP = false

	# 拿取运动向 -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# 依据方向翻转立绘
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false 
		
	# 播放关动画
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# 运动
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
