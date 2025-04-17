class_name Leaf

var bounds
var left
var right

func _init(b):
	bounds = b

func split():
	var axis = 0
	if bounds.size.y > bounds.size.x and bounds.size.y > bounds.size.z:
		axis = 1
	elif bounds.size.z > bounds.size.x:
		axis = 2
	var min_size = 4
	if bounds.size[axis] < min_size * 2:
		return false
	var cut_ratio = randf_range(0.4, 0.6)
	var cut = bounds.size[axis] * cut_ratio
	left = Leaf.new(AABB(bounds.position, bounds.size))
	right = Leaf.new(AABB(bounds.position, bounds.size))
	left.bounds.size[axis] = cut
	right.bounds.position[axis] += cut
	right.bounds.size[axis] -= cut
	return true
