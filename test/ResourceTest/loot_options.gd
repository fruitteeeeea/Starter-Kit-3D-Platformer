extends Resource
#资源文件作为一种数据存储容器

class_name LootOptions

@export var loot_level := 1
@export var loot_type := "PLyaer"

func duble_level():
	loot_level *= 2
