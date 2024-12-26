extends CanvasLayer

@onready var central_pos: Control = $CentralPos #游戏UI中心区域
var central_pos_panel := [] #当前中心区域展示的panel
@onready var top_right_pos: Control = $TopRightPos #游戏UI右上区域
var topright_pos_panel := [] #当前右上心区域展示的panel

@onready var massage: Control = $Massage

@onready var buff_icon: HBoxContainer = $BuffIcon
@onready var transition_screen: Control = $TransitionScreen

var current_pauseUI : Control #当前的暂停菜单
var current_Bufficon : Control #当前Buff栏位

@onready var loot_panel_pos: Control = $LootPanelPos
var current_LootUI : Control #当前的战利品选择UI

@onready var level_massage: Control = $LevelMassage #关卡信息UI

@onready var level_info_ui: Control = $LevelInfoUI #关卡内信息


func add_central_pos_panel(panel01 : PackedScene):
	var panel = panel01.instantiate() #生成UI节点
	central_pos.add_child(panel)
	central_pos_panel.append(panel) #添加到中心展示区域数组
	panel.tree_exiting.connect(remove_central_pos_panel.bind(panel)) #节点在离开场景树时， 将自己从数组中移除

func remove_central_pos_panel(panel01 : Node):
	central_pos_panel.erase(panel01)
