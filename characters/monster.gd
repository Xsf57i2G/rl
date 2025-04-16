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
		return
	var next = $Navigation.get_next_path_position()
	var direction = position.direction_to(next)
	move(direction)

func follow(target):
	$Navigation.target_position = target.position
	if !$Navigation.is_navigation_finished():
		var next = $Navigation.get_next_path_position()
		var direction = position.direction_to(next)
		move(direction)
