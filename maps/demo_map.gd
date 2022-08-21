extends Node2D
# Map should probably not contain network spawn code, but this is a prototype

var local_player = load("res://players/player.tscn")
var network_player = load("res://players/network_player.tscn")

onready var player_list = $PlayerList


# Called when the node enters the scene tree for the first time.
func _ready():
    Client.connect("spawn_local_player", self, "_on_spawn_local_player")
    Client.connect("spawn_new_player", self, "_on_spawn_new_player")
    Client.connect("spawn_network_players", self, "_on_spawn_network_players")
    
    
func _on_spawn_local_player(player: Dictionary) -> void:
    var lp = local_player.instance()
    lp.position = Vector2(player.x, player.y)
    player_list.add_child(lp)
    
    
func _on_spawn_new_player(player: Dictionary) -> void:
    _spawn_network_player(player)
    
    
func _on_spawn_network_players(players: Array) -> void:
    for player in players:
        if player.uuid != Client.uuid:
            _spawn_network_player(player)


func _spawn_network_player(player: Dictionary) -> void:
    var np = network_player.instance()
    np.position = Vector2(player.x, player.y)
    player_list.add_child(np)
