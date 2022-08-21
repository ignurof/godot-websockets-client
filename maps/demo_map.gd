extends Node2D
# Map should probably not contain network spawn code, but this is a prototype

var local_player = load("res://players/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    Client.connect("spawn_local_player", self, "_on_spawn_local_player")
    Client.connect("spawn_new_player", self, "_on_spawn_new_player")
    Client.connect("spawn_network_players", self, "_on_spawn_network_players")
    
    
func _on_spawn_local_player(player: Dictionary) -> void:
    var lp = local_player.instance()
    lp.position = Vector2(player.x, player.y)
    add_child(lp)
    
    
func _on_spawn_new_player() -> void:
    pass
    
    
func _on_spawn_network_players() -> void:
    pass
