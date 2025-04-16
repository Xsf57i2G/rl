class_name BSP

var root

func build(bounds, depth):
	root = Leaf.new(bounds)
	split(root, depth)

func split(leaf, depth):
	if depth <= 0 or not leaf.split():
		return
	split(leaf.left, depth - 1)
	split(leaf.right, depth - 1)

func leaves():
	var result = []
	collect(root, result)
	return result

func collect(leaf, result):
	if leaf.left and leaf.right:
		collect(leaf.left, result)
		collect(leaf.right, result)
	else:
		result.append(leaf)
