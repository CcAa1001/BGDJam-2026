extends CharacterBody2D

@export var speed: float = 120.0

# State Machine Dasar
enum State { IDLE, MOVE, INTERACT }
var current_state = State.IDLE

@onready var anim_player = $AnimationPlayer
@onready var interaction_zone = $InteractionZone

func _physics_process(_delta: float) -> void:
	match current_state:
		State.IDLE, State.MOVE:
			handle_movement()
		State.INTERACT:
			velocity = Vector2.ZERO # Berhenti saat berinteraksi
			
	move_and_slide()

func handle_movement():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		current_state = State.MOVE
		velocity = direction * speed
		# Logika sederhana untuk animasi (bisa dikembangkan dengan AnimationTree nanti)
		if direction.x != 0:
			anim_player.play("walk_side")
			$Sprite2D.flip_h = direction.x < 0
	else:
		current_state = State.IDLE
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		anim_player.play("idle_down")

func _input(event: InputEvent) -> void:
	# Tekan tombol 'Space' atau 'E' untuk berinteraksi
	if event.is_action_pressed("ui_accept"):
		check_interaction()

func check_interaction():
	# Mendapatkan semua benda yang masuk ke dalam InteractionZone
	var interactables = interaction_zone.get_overlapping_areas()
	if interactables.size() > 0:
		for area in interactables:
			if area.has_method("interact"):
				area.interact()
				# Kembali ke IDLE setelah interaksi selesai (bisa disesuaikan dengan sinyal nanti)
