class_name Prisoner extends Character

func _input(ev):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var eyes = $Camera
	if ev.is_action("Jump"):
		jump()
	if ev is InputEventMouseMotion:
		rotate_y(deg_to_rad(- (ev.relative.x)))
		eyes.rotate_x(deg_to_rad(- (ev.relative.y)))
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)

func _process(_dt):
	fall()
	var i = Input.get_vector("Left", "Right", "Forward", "Back")
	var d = (transform.basis * Vector3(i.x, 0, i.y)).normalized()
	move(d)
