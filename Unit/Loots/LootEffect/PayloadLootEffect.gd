extends LootEffect
class_name PayloadLootEffect

@export var LootPayloadArms : PackedScene

func apply_loot(): #添加战利品效果
	var arm = LootPayloadArms
	PayloadServer.current_payload_arms.append(arm)
