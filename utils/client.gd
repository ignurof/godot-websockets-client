extends Node
# Autoload Singleton that can be used for everything websocket client related

signal joined_server
signal spawn_local_player
signal spawn_new_player
signal spawn_network_players
signal update_position

var uuid: String = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
var _connected: bool = false

onready var _client: WebSocketClient = WebSocketClient.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _client.connect("connection_established", self, "_on_connection_established")
    _client.connect("connection_closed", self, "_on_connection_closed")
    _client.connect("connection_error", self, "_on_connection_error")
    _client.connect("data_received", self, "_on_data_received")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
    if _connected:
        _client.poll()


func _on_connection_established(protocol: String) -> void:
    print("Connection established - protocol: %s" % protocol)
    
    
func _on_connection_closed(was_clean_close: bool) -> void:
    print("Connection closed - was_clean_close: %s" % was_clean_close)
    _connected = false
    
    
func _on_connection_error() -> void:
    print("Connection error!")
    _connected = false
    
    
func _on_data_received() -> void:
#    print("Got data from server: ", _client.get_peer(1).get_packet())
    var received_data_variant = _client.get_peer(1).get_var()
    if received_data_variant is Dictionary and received_data_variant.has("cmd"):
        _handle_incoming_data(received_data_variant)
    else:
        push_error("_on_data_received ERROR!!")
            

func _handle_incoming_data(data: Dictionary) -> void:
#    printt("_handle_incoming_data", data)
    match data.cmd:
        "joined_server":
            printt(data.content.msg, data.content.uuid)
            uuid = data.content.uuid
            emit_signal("joined_server")
        "spawn_local_player":
            emit_signal("spawn_local_player", data.content.player)
        "spawn_new_player":
            emit_signal("spawn_new_player", data.content.player)
        "spawn_network_players":
            emit_signal("spawn_network_players", data.content.players)
        "update_position":
            emit_signal("update_position", data.content)
        _:
            push_error("_handle_incoming_data ERROR!!")


func connect_to_server() -> void:
    print("Attempting to establish connection to the server...")
    var error = _client.connect_to_url("ws://127.0.0.1:9090")
    if error != OK:
        push_error("Could not connect! Error: %s" % error)
        return
    _connected = true


func send(cmd: String, content: Dictionary) -> void:
    _client.get_peer(1).put_var({ "cmd": cmd, "content": content })
