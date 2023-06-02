extends Node2D

@export var spot_scene: PackedScene

var prep_move = false
var past_spot_id = []
var had_stone = 0
var curr_adj_spots = []

signal adj_spots_on(adj_spot_id_arr)
signal adj_spots_off(adj_spot_id_arr)
signal move_to_spot(id, past_spot_id, had_stone)

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
	
	$Music.play()
	
func _on_spot_clicked(id, has_stone):
	# No stone has been clicked yet, stone has now been clicked
	if !prep_move and has_stone > 0:
		# TODO handle_adj_highlight has sideeffect of turning on adj spots
		curr_adj_spots = handle_adj_highlight(id)
		
		prep_move = true
		past_spot_id = id
		had_stone = has_stone
		
	# Stone has been clicked in the past, empty adj apot has now been clicked
	elif prep_move and in_pos_arr(id, curr_adj_spots) and has_stone == 0:
		adj_spots_off.emit(curr_adj_spots)
		move_to_spot.emit(id, past_spot_id, had_stone)
		
		curr_adj_spots = []
		prep_move = false
		past_spot_id = null
		had_stone = 0
		

func handle_adj_highlight(id):
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
	
	var adj_spots = [left_adj, right_adj, vert_adj]
	adj_spots_on.emit(adj_spots)
	
	return adj_spots
	
	
func spawn_spots():
	for spot_info in spot_arr:
		var spot = spot_scene.instantiate()
		
		# Set vars of spot
		spot.my_id = [spot_info[0], spot_info[1]]
		spot.position = spot_info[2]
		
		spot.clicked.connect(_on_spot_clicked)
		add_child(spot)


func in_pos_arr(id, adj_spot_id_arr):
	for arr in adj_spot_id_arr:
		var level = arr[0]
		var pos = arr[1]
		
		if id[0] == level and id[1] == pos:
			return true
	
	return false
