extends Control
# Chat-system

onready var chat_box = $ScrollContainer/RichTextLabel

func _ready() -> void:
    Client.connect("new_chat_message", self, "_on_new_chat_message")


func _on_LineEdit_text_entered(new_text) -> void:
    chat_box.text += "\n" + new_text
    Client.send("chat", { "msg": new_text })


func _on_new_chat_message(content: Dictionary) -> void:
    chat_box.text += "\n" + content.msg


func _on_DummyControl_gui_input(event):
    print(event)
    if event is InputEventMouseButton:
        $LineEdit.hide()
        $LineEdit.show()
