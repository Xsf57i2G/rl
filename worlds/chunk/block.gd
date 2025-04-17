class_name Block

var id
var life = 1
var color

static var TYPE = {
	"STONE": Block.new("STONE", 1, Color.SLATE_GRAY),
	"BRICK": Block.new("BRICK", 3, Color.DIM_GRAY),
	"OBSIDIAN": Block.new("OBSIDIAN", INF, Color.DARK_SLATE_BLUE)
}

func _init(p_id, p_life, p_color):
	id = p_id
	life = p_life
	color = p_color
