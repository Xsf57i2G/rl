class_name BSP extends Resource

@export var depth = 4
var root

func build(b, d):
	root = Leaf.new(b)
	split(root, d)

func split(l, d):
	if d > 0 and l.split():
		split(l.l, d - 1)
		split(l.r, d - 1)

func leaves():
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
