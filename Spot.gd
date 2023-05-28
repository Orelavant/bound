extends Area2D

@export var spot_texture: Texture2D
@export var adj_spots: Array

var id
var mouse_present = false
var adj_spot_id_arr = []

signal clicked(id)
signal mouse_left(adj_spot_id_arr)

func _ready():
	get_parent().adj_spots_on.connect(adj_spot_on)
	get_parent().adj_spots_off.connect(adj_spot_off)

func _input(event):
	if event.is_action_pressed("click"):
		if mouse_present:
			clicked.emit(id)

func _on_mouse_entered():
	mouse_present = true
	texture_on()

func _on_mouse_exited():
	mouse_present = false
	texture_off()
	
	if !adj_spot_id_arr.is_empty():
		mouse_left.emit(self.adj_spot_id_arr)
		self.adj_spot_id_arr = []
	
func adj_spot_on(adj_spot_id_arr):
	self.adj_spot_id_arr = adj_spot_id_arr
	
	if in_pos_arr(id, adj_spot_id_arr):
		texture_on()
		
func adj_spot_off(adj_spot_id_arr):
	if in_pos_arr(id, adj_spot_id_arr):
		texture_off()
	
func spawn_piece():
	pass
	
func texture_on():
	$Sprite2D.set_texture(spot_texture)

func texture_off():
	$Sprite2D.set_texture(null)
	
func in_pos_arr(id, adj_spot_id_arr):
	for arr in adj_spot_id_arr:
		var level = arr[0]
		var pos = arr[1]
		
		if id[0] == level and id[1] == pos:
			return true
	
	return false
