class_name Monster extends Character

func _process(_dt):
	fall()
	wander()

func move(d):
	look_at(position + d)
	super.move(d)

func wander():
	if $Navigation.is_navigation_finished():
		var a = randf() * TAU
		var to = position + Vector3(cos(a), 0, sin(a)) * randf_range(4.0, 16.0)
		$Navigation.target_position = to
	var n = $Navigation.get_next_path_position()
	var d = position.direction_to(n)
	move(d)
