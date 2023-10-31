extends Node3D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var port_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/PortEntry

#to spawn the player scene for every peer
const Player = preload("res://scene/player.tscn")
const Player2 = preload("res://scene/player2.tscn")
var player_flag : bool = true
var ip_num : String = ""
var port_num : int = 0
var enet_peer = ENetMultiplayerPeer.new()
var max_players : int = 8

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed():
	ip_num = str(address_entry.text)
	port_num = int(port_entry.text)	
	#print("ip is %d" % ip_num)
	#print("port is %d" % port_num)
	main_menu.hide()
	
	#creat the server using the given IP and port number
	enet_peer.set_bind_ip(ip_num)
	enet_peer.create_server(port_num, max_players)
	multiplayer.multiplayer_peer = enet_peer
	#spawn connected players when there is a signal that a client id joined
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	player_flag = false
		
func _on_join_button_pressed():
	ip_num = str(address_entry.text)
	port_num = int(port_entry.text)	
	main_menu.hide()
	#creat the clinet using the given IP and port number
	enet_peer.create_client(ip_num, port_num)
	multiplayer.multiplayer_peer = enet_peer
	
#to add the players	to the server
func add_player(peer_id):
	if player_flag:
		var player = Player.instantiate()
		player.name = str(peer_id)
		add_child(player)
	else:
		var player = Player2.instantiate()
		player.name = str(peer_id)
		add_child(player)
