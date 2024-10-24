extends Node

var merchandise_list := [] #商品列表
var player_luck_value := 1.0 #根据幸运值补正刷新物品品质

@export var shop_ui : PackedScene #商店UI

var can_refresh := 0 #是否可以刷新 以及刷新次数

func change_ui(): #显示或者隐藏 UI
	pass

func spwan_merchan(): #刷新物品
	pass

func merchan_be_selected(): #选择某样商品
	pass

func do_refresh(): #刷新商店
	pass
