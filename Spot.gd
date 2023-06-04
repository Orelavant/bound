extends Area2D

@export var spot_texture: Texture2D
@export var white_piece_texture: Texture2D
@export var black_piece_texture: Texture2D
@export var adj_spots: Array

var my_id
var has_stone = 0 # 0 = no stone, 1 = black stone, 2 = white stone
var mouse_present = false

signal clicked(id)


func _ready():
	print("testing")
	
	# Connect signal to parent
	get_parent().adj_spots_on.connect(adj_spot_on)
	get_parent().adj_spots_off.connect(adj_spot_off)
	get_parent().move_to_spot.connect(spot_move)


func _input(event):
	if event.is_action_pressed("click"):
		if mouse_present:
			clicked.emit(my_id, has_stone)
			
	if event.is_action_pressed("right_click"):
		if mouse_present:
			if has_stone == 0:
				black_piece_texture_on()
				has_stone = 1
			elif has_stone == 1:
				piece_texture_off()
				white_piece_texture_on()
				has_stone = 2
			else:
				piece_texture_off()
				has_stone = 0


func spot_move(id, past_spot_id, had_stone):
	# If this is the spot to move to and no stone is present
	if my_id == id: 
		if had_stone == 1:
			black_piece_texture_on()
			has_stone = 1
		else:
			white_piece_texture_on()
			has_stone = 2
	
	# If this was the spot moved from
	if my_id == past_spot_id:
		has_stone = 0
		piece_texture_off()


func _on_mouse_entered():
	mouse_present = true


func _on_mouse_exited():
	mouse_present = false


func adj_spot_on(adj_spot_id_arr):
	if in_pos_arr(my_id, adj_spot_id_arr):
		highlight_texture_on()
	

func adj_spot_off(adj_spot_id_arr):
	if in_pos_arr(my_id, adj_spot_id_arr):
		highlight_texture_off()
	
	
func spawn_piece():
	pass
	
	
func highlight_texture_on():
	$SpotSprite.set_texture(spot_texture)
	

func highlight_texture_off():
	$SpotSprite.set_texture(null)


func black_piece_texture_on():
	$PieceSprite.set_texture(black_piece_texture)


func white_piece_texture_on():
	$PieceSprite.set_texture(white_piece_texture)
	
	
func piece_texture_off():
	$PieceSprite.set_texture(null)


func in_pos_arr(check_id, adj_spot_id_arr):
	for arr in adj_spot_id_arr:
		var level = arr[0]
		var pos = arr[1]
		
		if check_id[0] == level and check_id[1] == pos:
			return true
	
	return false
