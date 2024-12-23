extends LootEffect
class_name PayloadLootEffect

@export var LootPayloadArms : PackedScene
@export_enum("载具炸弹", "载具子弹", "载具近战") var ArmsName : String

func apply_loot(): #添加战利品效果
	var arm = LootPayloadArms
	PayloadServer.current_payload_arms.append(arm)
	print("修改 PayloadSatus")
