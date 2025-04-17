class_name BSP

var root

func build(b, d):
	root = Leaf.new(b)
	split(root, d)

func split(l, d):
	if d <= 0 or not l.split():
		return
	split(l.l, d - 1)
	split(l.r, d - 1)

func leaves():
	var r = []
	collect(root, r)
	return r

func collect(leaf, r):
	if leaf.l and leaf.r:
		collect(leaf.l, r)
		collect(leaf.r, r)
	else:
		r.append(leaf)
