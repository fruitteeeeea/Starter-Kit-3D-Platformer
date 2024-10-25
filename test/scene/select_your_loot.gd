extends Control

var defalt_posy := -900.0
var show_posy := 0.0

var move_tween : Tween

@export var LootOptionPannel : PackedScene #option 面板场景
@onready var loot_options: Control = $LootOptions
@onready var next_page_button: Button = $NextPageButton

@onready var remain_loot: Label = $PanelContainer/RemainLoot #剩余词条
@onready var select_your_loot_1_3_: Label = $"PanelContainer2/SelectYourLoot(1_3)" #当前页面

var current_loot_option := [] #当前面板的词条选项
var current_loot_option_num := 0 #当前面板的词条数量

#====UI显示====
var current_page := 1 #当前页数
var loots_pages := 3 #词条页数

var current_num := 0 #当前已选择词条数量
var loot_num := 6 #可选择词条数量

var UI_defult_value := [1, 3, 0, 6] #UI显示默认值

func _ready() -> void:
	position.y = defalt_posy
	spwan_loot_pannel()

#移动整个面板
func move_pannel(posy01 := defalt_posy, paused01 := false):
	restUI() #重置UI设定
	updateUI() #更新UI设定
	
	if move_tween:
		move_tween.kill()
	
	move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self, "position:y", posy01, .5)
	
	await get_tree().create_timer(.8).timeout
	get_tree().paused = paused01 #设定暂停

#出现选择的词条
func spwan_loot_pannel():
	for i in range(3): #生成 3 个 option 面板
		var loot_opption_pannel = LootOptionPannel.instantiate()
		loot_opption_pannel.loot_manager = self
		current_loot_option.append(loot_opption_pannel) #处理词条队列
		#current_loot_option_num = current_loot_option.size() #处理词条数量
		loot_options.add_child(loot_opption_pannel)
	
	current_loot_option_num = current_loot_option.size() #处理词条数量

#选择了一个奖赏
func loot_be_selected(pannel01 : PanelContainer = null):
	#首先 先增加对应属性
	#manager.add...
	
	#视觉效果
	var tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(pannel01, "position:y", position.y + 20.0, .3)
	tween.tween_property(pannel01, "modulate:a", 0.0, .3)
	await tween.finished
	
	current_loot_option_num -= 1 #更新当前词条数量
	if current_loot_option_num == 0: #当前面板词条数量为0 执行翻页操作
		do_next_page()
	
	current_num += 1 #战利品数量+1
	updateUI()
	
	if current_num == loot_num: #如果已经选择完成词条
		move_pannel()

#切换到下一页
func do_next_page():
	current_page += 1
	if current_page > loots_pages: #如果已经达到最大页数
		move_pannel()
		return
	
	
	updateUI()
	
	for i in current_loot_option: #清除当前的所有选项
		i.queue_free()
	
	current_loot_option.clear() #清除选项数组节点
	current_loot_option_num = 0 #重置当前标签计数
	spwan_loot_pannel() #重新生成词条标签


func updateUI(): #更新UI
	select_your_loot_1_3_.text = "选择你的战利品" + str(current_page) + "/" + str(loots_pages) #执行翻页操作的时候会更新
	remain_loot.text = "剩余战利品数量" + str(loot_num - current_num) #选择战利品之后会更新


func restUI(): #回复UI到默认值
	current_page = UI_defult_value[0]
	loots_pages = UI_defult_value[1]
	current_num = UI_defult_value[2]
	loot_num = UI_defult_value[3]


func _on_button_pressed() -> void:
	loot_be_selected()


func _on_next_page_button_pressed() -> void:
	do_next_page()
	
	#current_page += 1 #减少翻页次数
	#if current_page == loots_pages: #如果没有页数了 禁用翻页按钮
		#next_page_button.disabled
