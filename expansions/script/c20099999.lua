if fucs then return end
fucs = { }
--------------------------------------"fucg constants"
-- 效果type Effect type Variable
fucs.etyp = {
	A   = EFFECT_TYPE_ACTIVATE  ,
	I   = EFFECT_TYPE_IGNITION  , 
	QO  = EFFECT_TYPE_QUICK_O   ,
	QF  = EFFECT_TYPE_QUICK_F   ,
	TO  = EFFECT_TYPE_TRIGGER_O ,
	TF  = EFFECT_TYPE_TRIGGER_F ,
	F   = EFFECT_TYPE_FIELD  ,
	S   = EFFECT_TYPE_SINGLE	,
	C   = EFFECT_TYPE_CONTINUOUS,
	G   = EFFECT_TYPE_GRANT  ,
	E   = EFFECT_TYPE_EQUIP  ,
	X   = EFFECT_TYPE_XMATERIAL ,
}
-- 召唤类型 summon type Variable
fucs.styp = {
	NO  = SUMMON_TYPE_NORMAL	,   --通常召唤
	FU  = SUMMON_TYPE_FUSION	,   --融合召唤
	SY  = SUMMON_TYPE_SYNCHRO   ,   --同调召唤
	RI  = SUMMON_TYPE_RITUAL	,   --仪式召唤
	XYZ = SUMMON_TYPE_XYZ   ,   --超量召唤
	LI  = SUMMON_TYPE_LINK  ,   --连接召唤
	PE  = SUMMON_TYPE_PENDULUM  ,   --灵摆召唤
	AD  = SUMMON_TYPE_ADVANCE   ,   --上级召唤
	SP  = SUMMON_TYPE_SPECIAL   ,   --特殊召唤(EFFECT_SPSUMMON_PROC,EFFECT_SPSUMMON_PROC_G 可用Value修改數值)
	DU  = SUMMON_TYPE_DUAL  ,   --再度召唤（二重）
	FL  = SUMMON_TYPE_FLIP  ,   --翻转召唤
}
-- 客户端提示 Hint Variable
fucs.des = {
	--召唤
	S   = 1151  ,   --召唤
	SP  = 1152  ,   --特殊召唤
	SET = 1153  ,   --盖放
	FS  = 1154  ,   --反转召唤
	PE  = 1163  ,   --灵摆召唤
	SY  = 1164  ,   --同调召唤
	XYZ = 1165  ,   --超量召唤
	LI  = 1166  ,   --连接召唤
	AD  = 1167  ,   --上级召唤
	RI  = 1168  ,   --仪式召唤
	FU  = 1169  ,   --融合召唤
	--移动
	TH  = 1190  ,   --加入手卡
	TG  = 1191  ,   --送去墓地
	TD  = 1193  ,   --回到卡组
	--
	SH  = 20099999*16   ,   --检索
	RE  = 1192  ,   --除外
	DES = 20099999*16 + 1   ,   --破坏
	REL = 20099999*16 + 2   ,   --解放
	DR  = 20099999*16 + 3   ,   --抽卡
	EQ  = 20099999*16 + 4   ,   --装备
	HD  = 20099999*16 + 5   ,   --捨棄手牌
	DD  = 20099999*16 + 6   ,   --卡组送墓或特殊召唤
	--改变
	POS = 20099999*16 + 7   ,   --改变表示形式
	CON = 20099999*16 + 8   ,   --改变控制权
	ATK = 20099999*16 + 9   ,   --改变攻击
	DEF = 20099999*16 + 10  ,   --改变防御
	--基本分
	DAM = 20099999*16 + 11  ,   --基本分伤害
	REC = 20099999*16 + 12  ,   --基本分回复
	--特殊 (用于显示
	PUB = 66  ,   --持续公开
}
--category Variable
fucs.cat = {
	SH  = 0x20008   ,   --CATEGORY_SEARCH+CATEGORY_TOHAND
	--召唤
	S   = CATEGORY_SUMMON   , 
	SP  = CATEGORY_SPECIAL_SUMMON   ,
	FU  = CATEGORY_FUSION_SUMMON	,   --融合召唤效果（暴走魔法阵）
	--移动
	TD  = CATEGORY_TODECK   ,
	TG  = CATEGORY_TOGRAVE  ,
	TH  = CATEGORY_TOHAND   ,
	TE  = CATEGORY_TOEXTRA  ,
	--
	SE  = CATEGORY_SEARCH   ,
	RE  = CATEGORY_REMOVE   ,
	DES = CATEGORY_DESTROY  ,
	REL = CATEGORY_RELEASE  ,
	DR  = CATEGORY_DRAW  ,
	EQ  = CATEGORY_EQUIP	,
	HD  = CATEGORY_HANDES   ,   --捨棄手牌效果
	DD  = CATEGORY_DECKDES  ,   --包含從卡组送去墓地或特殊召唤效果
	--改变
	POS = CATEGORY_POSITION  ,   --改变表示形式效果
	CON = CATEGORY_CONTROL  ,   --改变控制权效果
	ATK = CATEGORY_ATKCHANGE	,   --改变攻击效果
	DEF = CATEGORY_DEFCHANGE	,   --改变防御效果
	--无效
	NEGA= CATEGORY_NEGATE   ,   --发动无效
	NEGE= CATEGORY_DISABLE  ,   --效果无效
	NEGS= CATEGORY_DISABLE_SUMMON   ,   --召唤无效
	--基本分
	DAM = CATEGORY_DAMAGE   ,   --伤害效果
	REC = CATEGORY_RECOVER  ,   --回复效果
	--其他
	TOK = CATEGORY_TOKEN	,   --含衍生物效果
	COUN= CATEGORY_COUNTER  ,   --指示物效果
	COIN= CATEGORY_COIN  ,   --硬币效果
	DICE= CATEGORY_DICE  ,   --骰子效果
	ANN = CATEGORY_ANNOUNCE ,   --發動時宣言卡名的效果
	--特殊cat
	GA  = CATEGORY_GRAVE_ACTION  ,   --包含特殊召喚以外移動墓地的卡的效果（屋敷わらし）
	GL  = CATEGORY_LEAVE_GRAVE  ,   --涉及墓地的效果(王家長眠之谷)
	GS  = CATEGORY_GRAVE_SPSUMMON   ,   --包含從墓地特殊召喚的效果（屋敷わらし、冥神）
}
--code Variable
fucs.cod = {
	--other
	FC  = EVENT_FREE_CHAIN  ,   --自由时点（强脱等，还有昴星团等诱发即时效果）
	ADJ = EVENT_ADJUST  ,   --adjust_all()调整後（御前试合）
	--移动
	TD  = EVENT_TO_DECK  ,
	TG  = EVENT_TO_GRAVE	,
	TH  = EVENT_TO_HAND  ,
	RE  = EVENT_REMOVE  ,
	MO  = EVENT_MOVE		,
	--召唤
	PS  = EVENT_SUMMON  ,   --召唤之际（怪兽还没上场、神宣等时点）
	PSP = EVENT_SPSUMMON			,   --特殊召唤之际
	PFS = EVENT_FLIP_SUMMON   ,   --翻转召唤之际
	S   = EVENT_SUMMON_SUCCESS  ,   --通常召唤成功时
	SP  = EVENT_SPSUMMON_SUCCESS	,   --特殊召唤成功时
	FS  = EVENT_FLIP_SUMMON_SUCCESS ,   --翻转召唤成功时
	--
	DR  = EVENT_DRAW				,   --抽卡时
	F   = EVENT_FLIP				,   --翻转时
	RO  = EVENT_DETACH_MATERIAL  ,   --去除超量素材时
	DES = EVENT_DESTROYED   ,   --被破坏时
	PDES= EVENT_DESTROY ,   --確定被破壞的卡片移動前
	LEA = EVENT_LEAVE_FIELD   ,   --离场时
	PLEA= EVENT_LEAVE_FIELD_P   ,   --離場的卡片移動前
	GLEA= EVENT_LEAVE_GRAVE   ,   --离开墓地时
	POS = EVENT_CHANGE_POS  ,   --表示形式变更时
	REL = EVENT_RELEASE ,   --解放时
	BM  = EVENT_BE_MATERIAL   ,   --作为同调/超量/连结素材、用于升级召唤的解放、作为仪式/融合召唤的素材
	PBM = EVENT_BE_PRE_MATERIAL  ,   --将要作为同调/超量/连结素材、用于升级召唤的解放
	HD  = EVENT_DISCARD ,   --丢弃手牌时
	--无效
	NEGA	= EVENT_CHAIN_NEGATED   ,   --发动无效
	NEGE	= EVENT_CHAIN_DISABLED  ,   --效果无效
	NEGS	= EVENT_SUMMON_NEGATED  ,   --召唤被无效时
	NEGFS   = EVENT_FLIP_SUMMON_NEGATED ,   --反转召唤被无效时
	NEGSP   = EVENT_SPSUMMON_NEGATED	,   --特殊召唤被无效时
	--连锁
	CH  = EVENT_CHAINING		,   --效果发动时
	CHED= EVENT_CHAIN_SOLVED	,   --连锁处理结束时
	----组合时点
	PHS  = EVENT_PHASE_START   ,
--[[
EVENT_CHAIN_SOLVING =1020   --连锁处理开始时（EVENT_CHAIN_ACTIVATING之後）
EVENT_CHAIN_ACTIVATING  =1021   --连锁处理准备中
EVENT_CHAIN_ACTIVATED   =1023   --N/A
EVENT_CHAIN_NEGATED =1024   --连锁发动无效时（EVENT_CHAIN_ACTIVATING之後）
EVENT_CHAIN_DISABLED			=1025   --连锁效果无效时
EVENT_CHAIN_END  =1026   --连锁串结束时
EVENT_BECOME_TARGET =1028   --成为效果对象时
EVENT_BREAK_EFFECT  =1050   --Duel.BreakEffect()被调用时
EVENT_MSET  =1106   --放置怪兽时
EVENT_SSET  =1107   --放置魔陷时
EVENT_DRAW  =1110   --抽卡时
EVENT_DAMAGE					=1111   --造成战斗/效果伤害时
EVENT_RECOVER   =1112   --回复生命值时
EVENT_PREDRAW   =1113   --抽卡阶段通常抽卡前
EVENT_CONTROL_CHANGED   =1120   --控制权变更
EVENT_EQUIP   =1121   --装备卡装备时
EVENT_ATTACK_ANNOUNCE   =1130   --攻击宣言时
EVENT_BE_BATTLE_TARGET  =1131   --被选为攻击对象时
EVENT_BATTLE_START  =1132   --伤害步骤开始时（反转前）
EVENT_BATTLE_CONFIRM			=1133   --伤害计算前（反转後）
EVENT_PRE_DAMAGE_CALCULATE  =1134   --伤害计算时（羽斬）
EVENT_DAMAGE_CALCULATING		=1135   --N/A
EVENT_PRE_BATTLE_DAMAGE   =1136   --即将产生战斗伤害(只能使用EFFECT_TYPE_CONTINUOUS)
EVENT_BATTLE_END				=1137   --N/A
EVENT_BATTLED   =1138   --伤害计算后（异女、同反转效果时点）
EVENT_BATTLE_DESTROYING   =1139   --以战斗破坏怪兽送去墓地时（BF-苍炎之修罗）
EVENT_BATTLE_DESTROYED  =1140   --被战斗破坏送去墓地时（杀人番茄等）
EVENT_DAMAGE_STEP_END   =1141   --伤害步骤结束时
EVENT_ATTACK_DISABLED   =1142   --攻击无效时（翻倍机会）
EVENT_BATTLE_DAMAGE =1143   --造成战斗伤害时
EVENT_TOSS_DICE  =1150   --掷骰子的结果产生后
EVENT_TOSS_COIN  =1151   --抛硬币的结果产生后
EVENT_TOSS_COIN_NEGATE  =1152   --重新抛硬币
EVENT_TOSS_DICE_NEGATE  =1153   --重新掷骰子
EVENT_LEVEL_UP  =1200   --等级上升时
EVENT_PAY_LPCOST				=1201   --支付生命值时
EVENT_RETURN_TO_GRAVE   =1203   --回到墓地时
EVENT_TURN_END  =1210   --回合结束时
EVENT_PHASE   =0x1000 --阶段结束时
EVENT_PHASE_START   =0x2000 --阶段开始时
EVENT_ADD_COUNTER   =0x10000 --增加指示物时
EVENT_REMOVE_COUNTER			=0x20000	--去除指示物时(A指示物)，Card.RemoveCounter()必須手動觸發此事件
--]]
}
--property Variable
fucs.pro = { 
	TG  = EFFECT_FLAG_CARD_TARGET   ,   --取对象效果
	PTG = EFFECT_FLAG_PLAYER_TARGET  ,   --含有"以玩家为对象"的特性（精靈之鏡）、影響玩家的永續型效果(SetTargetRange()改成指定玩家)
	CTG = EFFECT_FLAG_CONTINUOUS_TARGET ,   --建立持續對象的永續魔法/永續陷阱/早埋系以外的裝備魔法卡
	DE  = EFFECT_FLAG_DELAY ,   --場合型誘發效果、用於永續效果的EFFECT_TYPE_CONTINUOUS
	SR  = EFFECT_FLAG_SINGLE_RANGE  ,   --只对自己有效
	HINT= EFFECT_FLAG_CLIENT_HINT   ,   --客户端提示
	O   = EFFECT_FLAG_OATH  ,   --誓约效果
	AR  = EFFECT_FLAG_IGNORE_RANGE  ,   --影响所有区域的卡（大宇宙）
	IG  = EFFECT_FLAG_IGNORE_IMMUNE  ,   --无视效果免疫
	CD  = EFFECT_FLAG_CANNOT_DISABLE	,   --效果不会被无效
	CN  = EFFECT_FLAG_CAN_FORBIDDEN  ,   --可被禁止令停止適用的效果（與EFFECT_FLAG_CANNOT_DISABLE並用）
	CC  = EFFECT_FLAG_UNCOPYABLE		,   --不能复制的原始效果（效果外文本）
	SET = EFFECT_FLAG_SET_AVAILABLE  ,   --裡側狀態可發動的效果、影响场上里侧的卡的永續型效果
	DAM = EFFECT_FLAG_DAMAGE_STEP   ,   --可以在伤害步骤发动
	CAL = EFFECT_FLAG_DAMAGE_CAL		,   --可以在伤害计算时发动
	OP  = EFFECT_FLAG_EVENT_PLAYER  ,   --发动/处理效果的玩家为触发事件的玩家而不是卡片的持有者，如仪式魔人，万魔殿
	NR  = EFFECT_FLAG_NO_TURN_RESET  ,   --发条等“这张卡在场上只能发动一次”的效果
	OE  = 0x40400		  ,   --EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE(out effect)
}
--Location Variable
fucs.ran = {
	["1"] = 1,
	["0"] = 0,
	["H"] = LOCATION_HAND   ,
	["D"] = LOCATION_DECK   ,
	["G"] = LOCATION_GRAVE  ,
	["R"] = LOCATION_REMOVED,
	["E"] = LOCATION_EXTRA  ,
	["M"] = LOCATION_MZONE  ,
	["S"] = LOCATION_SZONE  ,
	["F"] = LOCATION_FZONE  ,
	["O"] = LOCATION_OVERLAY,
	["P"] = LOCATION_PZONE  ,
	["A"] = 0xff 
}
--Phase Variable
fucs.pha = {
	DP  = PHASE_DRAW		,   --抽卡阶段
	SP  = PHASE_STANDBY  ,   --准备阶段
	M1  = PHASE_MAIN1   ,   --主要阶段1
	BPS = PHASE_BATTLE_START,   --战斗阶段开始
	BP  = PHASE_BATTLE_STEP ,   --战斗步驟
	DS  = PHASE_DAMAGE  ,   --伤害步驟
	DC  = PHASE_DAMAGE_CAL  ,   --伤害计算时
	BPE = PHASE_BATTLE  ,   --战斗阶段結束
	M2  = PHASE_MAIN2   ,   --主要阶段2
	ED  = PHASE_END   ,   --结束阶段
}
--Reset Variable
fucs.res = {
	SELF = RESET_SELF_TURN  ,
	OPPO = RESET_OPPO_TURN  ,
	CH   = RESET_CHAIN  ,
	-- 以下自动添加 RESET_EVENT
	DIS  = RESET_DISABLE	,
	SET  = RESET_TURN_SET   ,
	TG   = RESET_TOGRAVE	,
	TH   = RESET_TOHAND  ,
	TD   = RESET_TODECK  ,
	TF   = RESET_TOFIELD	,
	RE   = RESET_REMOVE  ,
	TRE  = RESET_TEMP_REMOVE,
	LEA  = RESET_LEAVE  ,
	CON  = RESET_CONTROL	,
	O   = RESET_OVERLAY , 
	MSC  = RESET_MSCHANGE   ,
	----组合时点
	STD  = RESETS_STANDARD  ,
	RED  = RESETS_REDIRECT  ,
	-- 自动添加
	PH   = RESET_PHASE  ,
	EV   = RESET_EVENT  ,
}
--reason Variable
fucs.rea = {
	--召唤
	S   = REASON_SUMMON   , 
	SP  = REASON_SPSUMMON   ,
	--移动
	DES = REASON_DESTROY		,  --破坏
	REL = REASON_RELEASE		,  --解放
	BAT = REASON_BATTLE   ,  --战斗破坏
	EFF = REASON_EFFECT   ,  --效果
	--素材
	MAT = REASON_MATERIAL   ,   --作为融合/同调/超量素材或用於儀式/升級召喚
	FU  = REASON_FUSION   , 
	SY  = REASON_SYNCHRO		, 
	RI  = REASON_RITUAL   , 
	XYZ = REASON_XYZ			,  
	LI  = REASON_LINK   , 
	--特殊rea
	COS = REASON_COST   ,   --用於代價或無法支付代價而破壞
	REP = REASON_REPLACE		,   --代替
	TEM = REASON_TEMPORARY  ,   --暂时
	ADJ = REASON_ADJUST   ,   --调整（御前试合）
}
--position Variable
fucs.pos = {
	FUA = POS_FACEUP_ATTACK  ,   --表侧攻击
	FDA = POS_FACEDOWN_ATTACK   ,   --(reserved)
	FUD = POS_FACEUP_DEFENSE	,   --表侧守备
	FDD = POS_FACEDOWN_DEFENSE  ,   --里侧守备
	FU  = POS_FACEUP			,   --正面表示
	FD  = POS_FACEDOWN  ,   --背面表示
	A   = POS_ATTACK			,   --攻击表示
	D   = POS_DEFENSE   ,   --守备表示
}
--Attributes Variable
fucs.att = {
	A   = ATTRIBUTE_ALL  ,   --All
	EA  = ATTRIBUTE_EARTH   ,   --地
	WA  = ATTRIBUTE_WATER   ,   --水
	FI  = ATTRIBUTE_FIRE	,   --炎
	WI  = ATTRIBUTE_WIND	,   --风
	LI  = ATTRIBUTE_LIGHT   ,   --光
	DA  = ATTRIBUTE_DARK	,   --暗
	GO  = ATTRIBUTE_DIVINE  ,   --神
}
--race Variable
fucs.rac = {
	A   = RACE_ALL  , --All
	WA  = RACE_WARRIOR  ,   --战士
	SP  = RACE_SPELLCASTER  ,   --魔法师
	AN  = RACE_FAIRY		,   --天使
	DE  = RACE_FIEND		,   --恶魔
	ZO  = RACE_ZOMBIE   ,   --不死
	MA  = RACE_MACHINE  ,   --机械
	AQ  = RACE_AQUA   ,   --水
	PY  = RACE_PYRO   ,   --炎
	RO  = RACE_ROCK   ,   --岩石
	WB  = RACE_WINDBEAST	,   --鸟兽
	PL  = RACE_PLANT		,   --植物
	IN  = RACE_INSECT   ,   --昆虫
	TH  = RACE_THUNDER  ,   --雷
	DR  = RACE_DRAGON   ,   --龙
	BE  = RACE_BEAST		,   --兽
	BW  = RACE_BEASTWARRIOR ,   --兽战士
	DI  = RACE_DINOSAUR  ,   --恐龙
	FI  = RACE_FISH   ,   --鱼
	WD  = RACE_SEASERPENT   ,   --海龙
	RE  = RACE_REPTILE  ,   --爬虫类
	PS  = RACE_PSYCHO   ,   --念动力
	GB  = RACE_DIVINE   ,   --幻神兽
	GO  = RACE_CREATORGOD   ,   --创造神
	WY  = RACE_WYRM   ,   --幻龙
	CY  = RACE_CYBERSE  ,   --电子界
	IL  = RACE_ILLUSION ,  --幻想魔
}
--Card type Variable
fucs.typ = {
	M   = TYPE_MONSTER  ,   --怪兽卡
	S   = TYPE_SPELL	,   --魔法卡
	T   = TYPE_TRAP  ,   --陷阱卡
	NO  = TYPE_NORMAL   ,   --通常
	EF  = TYPE_EFFECT   ,   --效果
	--
	FU  = TYPE_FUSION   ,   --融合
	RI  = TYPE_RITUAL   ,   --仪式
	SY  = TYPE_SYNCHRO  ,   --同调
	XYZ = TYPE_XYZ  ,   --超量
	PE  = TYPE_PENDULUM ,   --灵摆
	LI  = TYPE_LINK  ,   --连接
	--
	SP  = TYPE_SPSUMMON ,   --特殊召唤
	SPI = TYPE_SPIRIT   ,   --灵魂
	UN  = TYPE_UNION	,   --同盟
	DU  = TYPE_DUAL  ,   --二重
	TU  = TYPE_TUNER	,   --调整
	FL  = TYPE_FLIP  ,   --翻转
	--
	TOK = TYPE_TOKEN		,   --衍生物
	QU  = TYPE_QUICKPLAY	,   --速攻
	CON = TYPE_CONTINUOUS   ,   --永续
	EQ  = TYPE_EQUIP		,   --装备
	FI  = TYPE_FIELD		,   --场地
	COU = TYPE_COUNTER  ,   --反击
	TM  = TYPE_TRAPMONSTER  ,   --陷阱怪兽
}
--Value Variable
fucs.val = {
	--Summon Type --召唤类型
	NO  = SUMMON_TYPE_NORMAL	,
	AD  = SUMMON_TYPE_ADVANCE   ,
	DU  = SUMMON_TYPE_DUAL  ,
	FL  = SUMMON_TYPE_FLIP  ,
	SP  = SUMMON_TYPE_SPECIAL   ,
	FU  = SUMMON_TYPE_FUSION	,
	RI  = SUMMON_TYPE_RITUAL	,
	SY  = SUMMON_TYPE_SYNCHRO   ,
	XYZ = SUMMON_TYPE_XYZ   ,
	PE  = SUMMON_TYPE_PENDULUM  ,
	LI  = SUMMON_TYPE_LINK  ,
	--Summon Value --特定的召唤方式
	SELF = SUMMON_VALUE_SELF	,
	SYM  = SUMMON_VALUE_SYNCHRO_MATERIAL 
}