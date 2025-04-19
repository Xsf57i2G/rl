class_name Leaf

var b
var l
var r

func _init(b):
	self.b = b

func split():
	var s = b.size
	var i = s.max_axis_index()
	if s[i] < 4:
		return false
	var c = s[i] * randf_range(0.4, 0.6)
	var a = AABB(b.position, b.size)
	var b = AABB(b.position, b.size)
	a.size[i] = c
	b.position[i] += c
	b.size[i] -= c
	l = Leaf.new(a)
	r = Leaf.new(b)
	return true
