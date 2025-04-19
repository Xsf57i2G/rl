@tool

class_name BSP extends Resource

@export var depth = 3
var root

func build(b, d):
	root = Leaf.new(b)
	if not d is int or d < 0:
		d = depth
	split(root, d)

func split(l, d):
	if l == null or not d is int or d < 0:
		return
	if d > 0 and l.split():
		split(l.l, d - 1)
		split(l.r, d - 1)

func find():
	var r = []
	var q = [root]
	while q:
		var n = q.pop_front()
		if n.l:
			q.push_back(n.l)
			q.push_back(n.r)
		else:
			r.append(n)
	return r
