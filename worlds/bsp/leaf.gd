class_name Leaf

var bounds
var left
var right

func _init(b):
	bounds = b

func split():
	var axis = randi() % 3
	var m = 4
	if bounds.size[axis] < m * 2:
		return false
	var cut = randf_range(m, bounds.size[axis] - m)
	left = Leaf.new(AABB(bounds.position, bounds.size))
	right = Leaf.new(AABB(bounds.position, bounds.size))
	left.bounds.size[axis] = cut
	right.bounds.position[axis] += cut
	right.bounds.size[axis] -= cut
	return true
