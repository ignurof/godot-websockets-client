extends Control


func _on_Button_pressed() -> void:
    Client.connect_to_server()
