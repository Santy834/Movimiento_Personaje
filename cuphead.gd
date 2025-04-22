extends CharacterBody2D


const SPEED_NORMAL = 300.0
const SPEED_DASH = 10000.0
const JUMP_VELOCITY = -500.0

var EstadoPJ
func _physics_process(delta: float) -> void:
	#Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("saltar"):
		EstadoPJ = "saltando"
		estado()

	if Input.is_action_pressed("parry") and not is_on_floor():
		EstadoPJ = "parry"
		estado()




	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("izquierda", "derecha")
	var velocidad = SPEED_NORMAL

	if direction:
		EstadoPJ = "caminando"
		if Input.is_action_pressed("izquierda"):
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_pressed("derecha"):
			$AnimatedSprite2D.flip_h = false
		velocity.x = direction * velocidad
		estado()

	elif is_on_floor():
		EstadoPJ = "parado"
		velocity.x = move_toward(velocity.x, 0, velocidad)
		estado()
		
	if  Input.is_action_just_pressed("dash"):
		velocidad = SPEED_DASH
		$Timer.wait_time = 1.5
		velocity.x = direction * velocidad
		EstadoPJ = "dash"
		estado()
		$Timer.start()
		
		
	move_and_slide()

func estado():
	if EstadoPJ == "saltando":
		$AnimatedSprite2D.play("Saltar")
	if EstadoPJ == "caminando" and is_on_floor():
		$AnimatedSprite2D.play("Caminar")
	if EstadoPJ == "parado":
		$AnimatedSprite2D.play("De_pie")
	if EstadoPJ == "parry":
		$AnimatedSprite2D.play("Parry")
	if EstadoPJ == "dash":
		$AnimatedSprite2D.play("Dash")

# Nota Apartado
# No logre hacer funcionar el parry. Conecte la señal "Body_entered" del nodo Area2D a el CharacterBody pero al crear un if para validar que
# El estado del personaje sea el del "parry" la señar no se enviaba y no logro entender bien el porqué.

#Por otro lado, el Dash no se vio como pense que se vería busque información en internet y no quedo como me lo imagene, mi idea era que el 
#Personaje se dezlice pero no lo consegui, más bien se teletransporta. Prefiero dejarlo hasta aqui porque me estuve rompiendo la cabeza para
#conseguir que el parry ande. El error creo que estuvo en anidar asquerosamente todos los if dentro del physics_process. Para futuro lo 
#lo tendre en cuenta y creare funciones para cada accion.
