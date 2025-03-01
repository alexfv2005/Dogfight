# multiplayer.gd
extends Node

const PORT = 4433

func _ready():
	#Pause the game at the start
	get_tree().paused = true
	#Bandwidth saving
	multiplayer.server_relay = false

	#Run in Headless mode
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()


func _on_host_pressed():
	#Start the Server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	
	#Signals
	peer.peer_connected.connect(_on_peer_connected)
	
	multiplayer.multiplayer_peer = peer
	start_game()


func _on_connect_pressed():
	# Start the client.
	var txt : String = $UI/Menu/Ip.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	
	multiplayer.multiplayer_peer = peer
	
	#Signals
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	
	start_game()


func start_game():
	$UI.hide()
	get_tree().paused = false

func _on_peer_connected(id):
	print("Peer connected. Id: ", id)
	
func _on_peer_disconnected(id):
	print("Peer disconnected. Id: ", id)
	
func _on_connection_failed():
	print("Failed to connect to server")

func _on_connected_to_server():
	print("Connected to Server")
