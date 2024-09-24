extends State



func start():
	change_state.emit(get_parent().get_node("Chasing"))
