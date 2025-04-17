class_name Leaf

var bounds
var l
var r

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
	l = Leaf.new(AABB(bounds.position, bounds.size))
	r = Leaf.new(AABB(bounds.position, bounds.size))
	l.bounds.size[axis] = cut
	r.bounds.position[axis] += cut
	r.bounds.size[axis] -= cut
	return true
