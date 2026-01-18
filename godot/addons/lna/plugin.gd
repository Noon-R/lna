@tool
extends EditorPlugin

func _enter_tree():
	# Called when the plugin is activated
	print("LNA plugin activated")

func _exit_tree():
	# Called when the plugin is deactivated
	print("LNA plugin deactivated")
