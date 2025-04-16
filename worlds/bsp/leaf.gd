class_name Leaf

var bounds
var left
var right

func _init(b):
	bounds = b

func split():
	var axis = randi() % 3
	var min_size = 4
	if bounds.size[axis] < min_size * 2:
		return false
	var cut = randf_range(min_size, bounds.size[axis] - min_size)
	left = Leaf.new(AABB(bounds.position, bounds.size))
	right = Leaf.new(AABB(bounds.position, bounds.size))
	left.bounds.size[axis] = cut
	right.bounds.position[axis] += cut
	right.bounds.size[axis] -= cut
	return true
