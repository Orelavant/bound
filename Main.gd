extends Node2D

@export var white_piece_scene: PackedScene
@export var black_piece_scene: PackedScene
@export var spot_scene: PackedScene

signal adj_spots_on(adj_spot_id_arr)
signal adj_spots_off(adj_spot_id_arr)

var spot_arr = [
	[0, 0, Vector2(403, 410)],
	[0, 1, Vector2(476, 391)],
	[0, 2, Vector2(520, 456)],
	[0, 3, Vector2(473, 510)],
	[0, 4, Vector2(403, 495)],
	[1, 0, Vector2(333, 370)],
	[1, 1, Vector2(377, 219)],
	[1, 2, Vector2(497, 310)],
	[1, 3, Vector2(650, 313)],
	[1, 4, Vector2(603, 449)],
	[1, 5, Vector2(654, 597)],
	[1, 6, Vector2(500, 591)],
	[1, 7, Vector2(379, 681)],
	[1, 8, Vector2(336, 541)],
	[1, 9, Vector2(211, 451)],
	[2, 0, Vector2(352, 132)],
	[2, 1, Vector2(733, 254)],
	[2, 2, Vector2(728, 646)],
	[2, 3, Vector2(352, 770)],
	[2, 4, Vector2(114, 449)]
]

func _ready():
	spawn_spots()

func _process(_delta):
	pass

func _on_spot_clicked(id):
	print(id)
	
	var level = id[0] 
	var pos = id[1]
	var mod_val = 5
	var level_change = 1
	var pos_change
	
	if level == 1:
		mod_val = 10
	
	# Level 1 alternates between going up and down, hence 2nd conditional
	if level == 2 or level == 1 and pos % 2 == 0:
		level_change = -1
		
	if level == 0:
		pos_change = pos
	elif level == 1 and level_change == -1:
		pos_change = -(pos/2)
	elif level == 1 and level_change == 1:
		pos_change = -ceil(pos/2.0)
	else:
		# This is the level 2 condition
		pos_change = pos + 1
	
	var left_adj = [level, posmod((pos - 1), mod_val)]
	var right_adj = [level, posmod((pos + 1), mod_val)]
	var vert_adj = [level + level_change, pos + pos_change]
	
	print(left_adj, right_adj, vert_adj)
	
	adj_spots_on.emit([left_adj, right_adj, vert_adj])

func _on_spot_mouse_left(adj_spot_arr):
	adj_spots_off.emit(adj_spot_arr)
	
func spawn_spots():
	for spot_info in spot_arr:
		var spot = spot_scene.instantiate()
		
		# Set vars of spot
		spot.id = [spot_info[0], spot_info[1]]
		spot.position = spot_info[2]
		
		spot.clicked.connect(_on_spot_clicked)
		spot.mouse_left.connect(_on_spot_mouse_left)
		add_child(spot)
	
	var black_piece = black_piece_scene.instantiate()
	black_piece.position = Vector2(300, 300)
	
	add_child(black_piece)
