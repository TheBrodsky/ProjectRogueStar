extends Trigger


@export var sub_trigger : Trigger 

var did_sub_trigger_activate : bool = false

func _ready():
	var child = get_child(0)
	if child is Trigger:
		sub_trigger = child
	
	if sub_trigger != null:
		sub_trigger.triggered.connect(_handle_subtrigger)


func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if did_sub_trigger_activate or sub_trigger == null:
			triggered.emit()
			if did_sub_trigger_activate:
				did_sub_trigger_activate = false
				sub_trigger.unpause()


func _handle_subtrigger():
	did_sub_trigger_activate = true
	sub_trigger.pause()
