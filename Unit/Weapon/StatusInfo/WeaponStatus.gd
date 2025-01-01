extends Status
class_name WeaponStatus
#管理武器的状态数据

@export var status_info := { #武器数据？
	#"attack_damage" : 10.0,
	#"attack_speed" : 1.2, 
	#"crithit_rate" : 0.2,
	#"crithit_damage" : 1.5,

	"bullet_number" : 0, #子弹倍率
	"bullet_damage" : 0.0, #子弹伤害
	"bullet_scale" : 0.0, #子弹体积
	"bullet_speed" : 0.0, #子弹速度加成
	"spread_angle" : 0.0, # 偏离的最大角度，以度数表示
	"random_speed" : 0.0, #随机速度（射程）
	"fire_colddown" : 0.0, #开火间隔
	"bullet_interval" : 0.0 #多发子弹枪之间的间隔
}
