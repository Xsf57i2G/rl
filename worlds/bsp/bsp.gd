class_name BSP

var root

func build(b, d, s = 0):
	if s != 0:
		seed(s)
	root = Leaf.new(b)
	split(root, d)

func split(leaf, d):
	if d <= 0 or not leaf.split():
		return
	split(leaf.left, d - 1)
	split(leaf.right, d - 1)

func leaves():
	var r = []
	collect(root, r)
	return r

func collect(leaf, r):
	if leaf.left and leaf.right:
		collect(leaf.left, r)
		collect(leaf.right, r)
	else:
		r.append(leaf)
