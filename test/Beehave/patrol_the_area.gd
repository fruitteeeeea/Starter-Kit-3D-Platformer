extends ActionLeaf

func before_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.set_value("target_pos", actor.pickrandom_pos())

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.animation_player.play("walk")
	actor.velocity = Vector3(blackboard.get_value("target_pos") - actor.global_position).normalized() * 0.5
	if actor.global_position.distance_to(blackboard.get_value("target_pos")) < 0.1:
		return SUCCESS
		
	return RUNNING
