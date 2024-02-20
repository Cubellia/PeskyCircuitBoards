extends Node2D

@export var slots:Node2D
@export var iron:Sprite2D

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if(event.as_text_key_label().contains("Kp ")):
				for action in InputMap.get_actions():#this is absolutely disgusting. do i really have to???? ffs
					if InputMap.action_has_event(action, event):
						var k = action.split('_')[1];
						iron.global_position=slots.find_child("square"+k).global_position
