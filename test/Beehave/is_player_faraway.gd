extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value("player_close") == true:
		return FAILURE

	else :
		return SUCCESS
	
