extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.animation_player.play("idle")
	return RUNNING
