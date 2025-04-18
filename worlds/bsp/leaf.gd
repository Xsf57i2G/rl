class_name Leaf

var bounds
var l
var r

func _init(b): bounds = b

func split():
	var s = bounds.size
	var a = s.max_axis_index()
	var c = s[a] * randf_range(0.4, 0.6)
	var b1 = bounds
	var b2 = bounds
	b1.size[a] = c
	b2.position[a] += c
	b2.size[a] -= c
	l = Leaf.new(b1)
	r = Leaf.new(b2)
	return true
