class_name Leaf

@export var min_split_ratio = 0.4
@export var max_split_ratio = 0.6
@export var min_size = 4
var bounds
var l
var r

func _init(b): bounds = b

func split():
	var s = bounds.size
	var a = s.max_axis_index()
	if s[a] < min_size * 2: return false
	var c = s[a] * randf_range(min_split_ratio, max_split_ratio)
	var b1 = bounds
	var b2 = bounds
	b1.size[a] = c
	b2.position[a] += c
	b2.size[a] -= c
	l = Leaf.new(b1)
	r = Leaf.new(b2)
	return true
