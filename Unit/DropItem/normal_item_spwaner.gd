extends Marker3D
#此处生成弹跳掉落物 

@export var Item : PackedScene #物品场景
@export var spwan_number := 3 #物品数量

func spwan_normal_item(number01 := spwan_number):
	for i in range(number01):
		var item = Item.instantiate()
		item.position = global_position
		get_tree().root.add_child(item)
		await get_tree().create_timer(.02).timeout
