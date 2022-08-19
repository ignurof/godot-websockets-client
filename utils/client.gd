extends Node
# Autoload Singleton that can be used for everything websocket client related

var connected: bool = false

onready var _client: WebSocketClient = WebSocketClient.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _client.connect("connection_established", self, "_on_connection_established")
    _client.connect("connection_closed", self, "_on_connection_closed")
#    _connect_to_server()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
    if connected:
        _client.poll()


func _on_connection_established(protocol: String) -> void:
    print("Connection established - protocol: %s" % protocol)
    
    
func _on_connection_closed(was_clean_close: bool) -> void:
    print("Connection closed - was_clean_close: %s" % was_clean_close)


func connect_to_server() -> void:
    print("hello")
    var error = _client.connect_to_url("ws://127.0.0.1:9090")
    if error != OK:
        push_error("Could not connect! Error: %s" % error)
        return
    connected = true
