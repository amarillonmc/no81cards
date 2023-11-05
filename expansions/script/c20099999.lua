if fucg then return end
fucg, fusf = { }, { }
--------------------------------------"Support function"
function fusf.CutString(str,cut,dis,from)
	if type(str) ~= "string" then Debug.Message(from) end
	local str = str..cut
	if dis and dis ~= "" then 
		for _,D in ipairs(fusf.CutString(dis,cut,nil,"CutString1")) do
			D = D .. cut
			str = str:gsub(D,"",1)
		end
	end
	local list, index, ch = {}, 1, ""
	while index <= #str do
		if str:sub(index, index):match(cut) then
			list[#list+1] = ch
			ch = ""
		else
			_, index, ch = str:find("^([^"..cut.."]+)", index)
		end
		index = index + 1
	end
	return list
end
function fusf.NotNil(val)   --table or string
	if type(val) == "table" or type(val) == "string" then return #val>0 end
	return val
end
function fusf.Loc(locs,chk,from)
	local Loc = {0,0}
	for i,loc in ipairs(fusf.CutString(locs,"+",nil,"fusf.Loc")) do
		for j = 1,#loc do
			Loc[i] = Loc[i] + fucg.ran[loc:sub(j,j):upper()]
		end
	end
	if chk then Loc = {Loc[1]} end
	return table.unpack(Loc)
end
function fusf.GetCardTable(c)
	local C = {}
	if aux.GetValueType(c) == "Effect" then
		C[1] = c:GetHandler()
	elseif aux.GetValueType(c) == "Card" then
		C[1] = c
	elseif aux.GetValueType(c) == "Group" then
		for i in aux.Next(c) do
			C[#C+1] = i
		end
	end
	return C 
end
function fusf.PostFix_Trans(str,val)
	local tTrans, tStack, index = { }, { }, 1
	while index <= #str do
		local ch = str:sub(index, index)
		if ch:match("%a") then
			_, index, ch = str:find("^([%a]+)", index)
			table.insert(tTrans, ch)
		elseif ch == "%" then
			local chk = table.remove(val, 1)
			if type(chk) == "boolean" then
				local b = chk
				chk = function() return b end
			end
			table.insert(tTrans, chk)
		elseif ch == "(" or ch == "~" then
			table.insert(tStack, ch)
		elseif ch == ")" then
			while #tStack > 0 and tStack[#tStack] ~= "(" do
				table.insert(tTrans, table.remove(tStack))
			end
			table.remove(tStack)
		elseif ch == "+" or ch == "-" then
			while #tStack > 0 and tStack[#tStack] ~= "(" do
				table.insert(tTrans, table.remove(tStack))
			end
			table.insert(tStack, ch)
		elseif ch == "/" then
			while #tStack > 0 and tStack[#tStack] == "/" do
				table.insert(tTrans, table.remove(tStack))
			end
			table.insert(tStack, ch)
		end
		if tStack[#tStack] == "~" and ch:match("^[%a%)%%]") then
			table.insert(tTrans, table.remove(tStack))
		end
		index = index + 1
	end
	while #tStack > 0 do
		table.insert(tTrans, table.remove(tStack))
	end
	return tTrans
end
function fusf.Value_Trans(...)
	local vals,var = {...},{ }
	for i,val in ipairs(vals) do
		if type(val) == "string" then
			for _,unit in ipairs(fusf.CutString(val,",",nil,"Value_Trans")) do
				table.insert(var, unit == "%" and table.remove(vals, i + 1) or unit == "" and { } or unit)
			end
		else
			table.insert(var, val or { })
		end
	end
	return var
end
function fusf.Check_Constant(func,chktable)
	return function(c,cons)
		if cons and type(cons) ~= "string" then return func(c,cons) end
		local Cons, tStack = fusf.PostFix_Trans(cons), { }
		local CalL, CalR
		for _,val in ipairs(Cons) do
			if val:match("[%-%~]") then
				tStack[#tStack] = not tStack[#tStack]
			elseif val:match("[%+%/]") then
				CalR = table.remove(tStack)
				CalL = table.remove(tStack)
				local tCal = {
					["+"] = CalL and CalR,
					["/"] = CalL or CalR
				}
				table.insert(tStack, tCal[val])
			else
				table.insert(tStack, func(c,chktable[val:upper()]))
			end
		end
		return tStack[#tStack]
	end
end
function fusf.Set_Constant(func,_constant)
	return function(E,val)
		if not fusf.NotNil(val) then return end
		local var = type(val) == "string" and 0 or val
		if func == "Code" and (val == "m" or type(val) == "string" and val:match("CUS")) then 
			val = val == "m" and E.e:GetOwner():GetCode() or tonumber(val:sub(5,#val))
			val = val < 19999999 and val + 20000000 or val
			Effect["SetCode"](E.e,EVENT_CUSTOM + val)
		else 
			if type(val) == "string" then 
				for _,V in ipairs(fusf.CutString(val,"+",nil,_constant:upper())) do
					var = var + (fusf.NotNil(V) and fucg[_constant][V:upper()] or 0)
				end
			end
			Effect["Set"..func](E.e,var)
		end
	end
end
function fusf.Set_Func(func)
	return function(E,val)
		if not (fusf.NotNil(val) and func) then return end
		local var
		if type(val) == "string" then 
			local cm,lib = _G["c"..E.e:GetOwner():GetCode()],E.e:GetOwner().lib or {}
			var = tonumber(val) or lib[val] or cm[val] or aux[val]
			if not var and func == "Value" then var = fucg.val[val] or var end
			if not var and val:match("*") then 
				local _val = fusf.CutString(val,"*",nil,"Func") 
				local _func = table.remove(_val,1)
				if aux[_func] then var = aux[_func](table.unpack(_val)) end
				if cm[_func] then var = cm[_func](table.unpack(_val)) end
				if lib[_func] then var = lib[_func](table.unpack(_val)) end
			end
		end
		Effect["Set"..func](E.e,var or val)
	end
end
--------------------------------------"fucg constants"
--Effect type Variable
fucg.etyp = {
	A   =EFFECT_TYPE_ACTIVATE,   
	I   =EFFECT_TYPE_IGNITION,   
	QO  =EFFECT_TYPE_QUICK_O,   
	QF  =EFFECT_TYPE_QUICK_F,   
	TO  =EFFECT_TYPE_TRIGGER_O,   
	TF  =EFFECT_TYPE_TRIGGER_F,   
	F   =EFFECT_TYPE_FIELD,   
	S   =EFFECT_TYPE_SINGLE,   
	C   =EFFECT_TYPE_CONTINUOUS,   
	G   =EFFECT_TYPE_GRANT,   
	E   =EFFECT_TYPE_EQUIP,   
	X   =EFFECT_TYPE_XMATERIAL,
}
--summon type Variable
fucg.styp = {
	NO = SUMMON_TYPE_NORMAL,
	FU  = SUMMON_TYPE_FUSION  , 
	SY  = SUMMON_TYPE_SYNCHRO  , 
	RI  = SUMMON_TYPE_RITUAL  , 
	XYZ = SUMMON_TYPE_XYZ  ,  
	LI  = SUMMON_TYPE_LINK  , 
	PE  = SUMMON_TYPE_PENDULUM  , 
	AD  = SUMMON_TYPE_ADVANCE  , 
	SP  =SUMMON_TYPE_SPECIAL,
	DU  =SUMMON_TYPE_DUAL, 
	FL  =SUMMON_TYPE_FLIP, 
}
--Hint Variable
fucg.des = {
	--召唤
	SP = 1152   ,  --特殊召唤
	--移动
	TH = 1190   ,  --加入手卡
	TG = 1191   ,  --送去墓地
	--
	RE = 1192   ,  --除外
	DES = 20099999*16   ,  --破坏
	DR = 20099999*16+1   ,  --抽卡
}
--category Variable
fucg.cat = {
	SH  = 0x20008   , --CATEGORY_SEARCH+CATEGORY_TOHAND
	--召唤
	S   = CATEGORY_SUMMON   , 
	SP  = CATEGORY_SPECIAL_SUMMON   ,
	FU  = CATEGORY_FUSION_SUMMON	, --融合召唤效果（暴走魔法阵）
	--移动
	TD  = CATEGORY_TODECK   ,
	TG  = CATEGORY_TOGRAVE  ,
	TH  = CATEGORY_TOHAND   ,
	TE  = CATEGORY_TOEXTRA   ,
	--
	SE  = CATEGORY_SEARCH   ,
	RE  = CATEGORY_REMOVE   ,
	DES = CATEGORY_DESTROY ,
	REL = CATEGORY_RELEASE   ,
	DR  = CATEGORY_DRAW ,
	EQ  = CATEGORY_EQUIP ,
	HD  = CATEGORY_HANDES ,  --捨棄手牌效果
	DD  = CATEGORY_DECKDES ,  --包含從卡组送去墓地或特殊召唤效果
	--改变
	POS = CATEGORY_POSITION   ,  --改变表示形式效果
	CON = CATEGORY_CONTROL   ,  --改变控制权效果
	ATK = CATEGORY_ATKCHANGE   ,  --改变攻击效果
	DEF = CATEGORY_DEFCHANGE   ,  --改变防御效果
	--无效
	NEGA= CATEGORY_NEGATE   ,  --发动无效
	NEGE= CATEGORY_DISABLE   , --效果无效
	NEGS= CATEGORY_DISABLE_SUMMON   , --召唤无效
	--基本分
	DAM = CATEGORY_DAMAGE   ,  --伤害效果
	REC = CATEGORY_RECOVER   , --回复效果
	--其他
	TOK = CATEGORY_TOKEN	,
	COUN= CATEGORY_COUNTER   ,  --指示物效果
	COIN= CATEGORY_COIN   , --硬币效果
	DICE= CATEGORY_DICE   , --骰子效果
	ANN = CATEGORY_ANNOUNCE   , --發動時宣言卡名的效果
	--特殊cat
	GA  = CATEGORY_GRAVE_ACTION , --包含特殊召喚以外移動墓地的卡的效果（屋敷わらし）
	GL  = CATEGORY_LEAVE_GRAVE , --涉及墓地的效果(王家長眠之谷)
	GS  = CATEGORY_GRAVE_SPSUMMON , --包含從墓地特殊召喚的效果（屋敷わらし、冥神）
}
--code Variable
fucg.cod = {
	--other
	FC   = EVENT_FREE_CHAIN   ,
	ADJ  = EVENT_ADJUST  ,
	--to location
	TD   = EVENT_TO_DECK   ,
	TG   = EVENT_TO_GRAVE  ,
	TH   = EVENT_TO_HAND   ,
	RE   = EVENT_REMOVE   ,
	MO  = EVENT_MOVE,
	--Change
	RO   = EVENT_DETACH_MATERIAL,
	PS   = EVENT_SUMMON   ,
	S   = EVENT_SUMMON_SUCCESS   ,
	PSP  = EVENT_SPSUMMON   ,
	SP   = EVENT_SPSUMMON_SUCCESS   ,
	PF   = EVENT_FLIP_SUMMON   ,
	F   = EVENT_FLIP_SUMMON_SUCCESS   ,
	DES  = EVENT_DESTROYED   ,
	PDES = EVENT_DESTROY   ,
	LEA  = EVENT_LEAVE_FIELD,
	PLEA  = EVENT_LEAVE_FIELD_P,
	GLEA  = EVENT_LEAVE_GRAVE,
	POS  = EVENT_CHANGE_POS,
	REL  = EVENT_RELEASE,
	BM   = EVENT_BE_MATERIAL,
	PBM   = EVENT_BE_PRE_MATERIAL,
	--negative
	NEGA = EVENT_CHAIN_NEGATED   ,  --发动无效
	NEGE = EVENT_CHAIN_DISABLED   , --效果无效
	NEGS = EVENT_SUMMON_NEGATED,
	NEGF = EVENT_FLIP_SUMMON_NEGATED,
	NEGSP = EVENT_SPSUMMON_NEGATED,
	--chain
	CH   = EVENT_CHAINING   ,
--[[
EVENT_FLIP  =1001   --翻转时
EVENT_DISCARD	 =1018   --丢弃手牌时
EVENT_CHAIN_SOLVING =1020   --连锁处理开始时（EVENT_CHAIN_ACTIVATING之後）
EVENT_CHAIN_ACTIVATING  =1021   --连锁处理准备中
EVENT_CHAIN_SOLVED  =1022   --连锁处理结束时
EVENT_CHAIN_ACTIVATED   =1023   --N/A
EVENT_CHAIN_NEGATED =1024   --连锁发动无效时（EVENT_CHAIN_ACTIVATING之後）
EVENT_CHAIN_DISABLED			=1025   --连锁效果无效时
EVENT_CHAIN_END  =1026   --连锁串结束时
EVENT_CHAINING  =1027   --效果发动时
EVENT_BECOME_TARGET =1028   --成为效果对象时
EVENT_BREAK_EFFECT  =1050   --Duel.BreakEffect()被调用时
EVENT_MSET  =1106   --放置怪兽时
EVENT_SSET  =1107   --放置魔陷时
EVENT_DRAW  =1110   --抽卡时
EVENT_DAMAGE					=1111   --造成战斗/效果伤害时
EVENT_RECOVER	 =1112   --回复生命值时
EVENT_PREDRAW	 =1113   --抽卡阶段通常抽卡前
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
EVENT_BATTLED	 =1138   --伤害计算后（异女、同反转效果时点）
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
EVENT_CUSTOM					=0x10000000 --自訂事件
--]]
}
--property Variable
fucg.pro = { 
	TG  = EFFECT_FLAG_CARD_TARGET   ,
	PTG   = EFFECT_FLAG_PLAYER_TARGET   ,
	CTG = EFFECT_FLAG_CONTINUOUS_TARGET   ,
	DE  = EFFECT_FLAG_DELAY  ,
	SR  = EFFECT_FLAG_SINGLE_RANGE   ,
	HINT  = EFFECT_FLAG_CLIENT_HINT   ,
	O   = EFFECT_FLAG_OATH   ,
	AR  = EFFECT_FLAG_IGNORE_RANGE   ,
	IG  = EFFECT_FLAG_IGNORE_IMMUNE   ,
	CD  = EFFECT_FLAG_CANNOT_DISABLE   ,
	CN  = EFFECT_FLAG_CANNOT_NEGATE   ,
	CC  = EFFECT_FLAG_UNCOPYABLE   ,
	SET   = EFFECT_FLAG_SET_AVAILABLE   ,
	DAM   = EFFECT_FLAG_DAMAGE_STEP  ,
	CAL   = EFFECT_FLAG_DAMAGE_CAL  ,
	OP   = EFFECT_FLAG_EVENT_PLAYER,
	OE  = 0x40400   , --EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE(out effect)
}
--Location Variable
fucg.ran = {
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
fucg.pha = {
	DP  = PHASE_DRAW   ,  --抽卡阶段
	SP  = PHASE_STANDBY  ,  --准备阶段
	M1  = PHASE_MAIN1   ,  --主要阶段1
	BPS = PHASE_BATTLE_START ,  --战斗阶段开始
	BP  = PHASE_BATTLE_STEP  ,  --战斗步驟
	DS  = PHASE_DAMAGE   ,  --伤害步驟
	DC  = PHASE_DAMAGE_CAL   ,  --伤害计算时
	BPE = PHASE_BATTLE   ,  --战斗阶段結束
	M2  = PHASE_MAIN2   ,  --主要阶段2
	ED  = PHASE_END  ,  --结束阶段
}
--Reset Variable
fucg.res = {
	SELF = RESET_SELF_TURN,
	OPPO = RESET_OPPO_TURN,
	PH   = RESET_PHASE,
	CH   = RESET_CHAIN,
	EV   = RESET_EVENT,
	DIS  = RESET_DISABLE,
	SET  = RESET_TURN_SET,
	TG   = RESET_TOGRAVE,
	TH   = RESET_TOHAND,
	TD   = RESET_TODECK,
	TF   = RESET_TOFIELD,
	RE   = RESET_REMOVE,
	TRE  = RESET_TEMP_REMOVE,
	LEA  = RESET_LEAVE,
	CON  = RESET_CONTROL,
	O   = RESET_OVERLAY,
	MSC  = RESET_MSCHANGE,
	----组合时点
	STD  = RESETS_STANDARD,
	RED  = RESETS_REDIRECT, 
	_PH  = fucg.pha,
}
--count limit Variable
fucg.ctl = {
	O = EFFECT_COUNT_CODE_OATH  ,  --发动次数
	D = EFFECT_COUNT_CODE_DUEL  ,  --决斗次数
	S = EFFECT_COUNT_CODE_SINGLE  ,  --公共次数
}
--reason Variable
fucg.rea = {
	--召唤
	S   = REASON_SUMMON   , 
	SP  = REASON_SPSUMMON   ,
	--移动
	DES = REASON_DESTROY  ,  --破坏
	REL = REASON_RELEASE  ,  --解放
	BAT = REASON_BATTLE  ,  --战斗破坏
	EFF = REASON_EFFECT  ,  --效果
	--素材
	MAT = REASON_MATERIAL  ,  --作为融合/同调/超量素材或用於儀式/升級召喚
	FU  = REASON_FUSION  , 
	SY  = REASON_SYNCHRO  , 
	RI  = REASON_RITUAL  , 
	XYZ = REASON_XYZ  ,  
	LI  = REASON_LINK  , 
	--特殊rea
	COS = REASON_COST  ,  --用於代價或無法支付代價而破壞
	REP = REASON_REPLACE  ,  --代替
	TEM = REASON_TEMPORARY  ,  --暂时
	ADJ = REASON_ADJUST  ,  --调整（御前试合）
}
--position Variable
fucg.pos = {
	FUA = POS_FACEUP_ATTACK ,   --表侧攻击
	FDA = POS_FACEDOWN_ATTACK  ,  --(reserved)
	FUD = POS_FACEUP_DEFENSE  ,  --表侧守备
	FDD = POS_FACEDOWN_DEFENSE  ,  --里侧守备
	FU  = POS_FACEUP  ,  --正面表示
	FD  = POS_FACEDOWN  ,  --背面表示
	A   = POS_ATTACK  ,  --攻击表示
	D   = POS_DEFENSE  ,  --守备表示
}
--Attributes Variable
fucg.att = {
	A   = ATTRIBUTE_ALL ,   --All
	EA  = ATTRIBUTE_EARTH  ,  --地
	WA  = ATTRIBUTE_WATER  ,  --水
	FI  = ATTRIBUTE_FIRE  ,  --炎
	WI  = ATTRIBUTE_WIND  ,  --风
	LI  = ATTRIBUTE_LIGHT  ,  --光
	DA  = ATTRIBUTE_DARK  ,  --暗
	GO  = ATTRIBUTE_DIVINE  ,  --神
}
--race Variable
fucg.rac = {
	A   = RACE_ALL ,   --All
	WA  = RACE_WARRIOR  ,  --战士
	SP  = RACE_SPELLCASTER  ,  --魔法师
	AN  = RACE_FAIRY  ,  --天使
	DE  = RACE_FIEND  ,  --恶魔
	ZO  = RACE_ZOMBIE  ,  --不死
	MA  = RACE_MACHINE  ,  --机械
	AQ  = RACE_AQUA  ,  --水
	PY  = RACE_PYRO  ,  --炎
	RO  = RACE_ROCK  ,  --岩石
	WB  = RACE_WINDBEAST  ,  --鸟兽
	PL  = RACE_PLANT  ,  --植物
	IN  = RACE_INSECT  ,  --昆虫
	TH  = RACE_THUNDER  ,  --雷
	DR  = RACE_DRAGON  ,  --龙
	BE  = RACE_BEAST  ,  --兽
	BW  = RACE_BEASTWARRIOR  ,  --兽战士
	DI  = RACE_DINOSAUR  ,  --恐龙
	FI  = RACE_FISH  ,  --鱼
	WD  = RACE_SEASERPENT  ,  --海龙
	RE  = RACE_REPTILE  ,  --爬虫类
	PS  = RACE_PSYCHO  ,  --念动力
	GB  = RACE_DIVINE  ,  --幻神兽
	GO  = RACE_CREATORGOD  ,  --创造神
	WY  = RACE_WYRM  ,  --幻龙
	CY  = RACE_CYBERSE  ,  --电子界
}
--Card type Variable
fucg.typ = {
	M   =TYPE_MONSTER,   --怪兽卡
	S   =TYPE_SPELL,   --魔法卡
	T   =TYPE_TRAP,   --陷阱卡
	NO  =TYPE_NORMAL,   --通常
	EF  =TYPE_EFFECT,   --效果
	--
	FU  =TYPE_FUSION,   --融合
	RI  =TYPE_RITUAL,   --仪式
	SY  =TYPE_SYNCHRO,   --同调
	XYZ =TYPE_XYZ,   --超量
	PE  =TYPE_PENDULUM,  --灵摆
	LI  =TYPE_LINK,   --连接
	--
	SP  =TYPE_SPSUMMON,  --特殊召唤
	SPI =TYPE_SPIRIT,   --灵魂
	UN  =TYPE_UNION,   --同盟
	DU  =TYPE_DUAL,   --二重
	TU  =TYPE_TUNER,   --调整
	FL  =TYPE_FLIP,   --翻转
	--
	TOK =TYPE_TOKEN,   --衍生物
	QU  =TYPE_QUICKPLAY,  --速攻
	CON =TYPE_CONTINUOUS,   --永续
	EQ  =TYPE_EQUIP,   --装备
	FI  =TYPE_FIELD,   --场地
	COU =TYPE_COUNTER,   --反击
	TM  =TYPE_TRAPMONSTER,   --陷阱怪兽
}
--Value Variable
fucg.val = {
	--Summon Type --召唤类型
	NO  =SUMMON_TYPE_NORMAL,
	AD  =SUMMON_TYPE_ADVANCE,
	DU  =SUMMON_TYPE_DUAL,
	FL  =SUMMON_TYPE_FLIP,
	SP  =SUMMON_TYPE_SPECIAL,
	FU  =SUMMON_TYPE_FUSION,
	RI  =SUMMON_TYPE_RITUAL,
	SY  =SUMMON_TYPE_SYNCHRO,
	XYZ  =SUMMON_TYPE_XYZ,
	PE  =SUMMON_TYPE_PENDULUM,
	LI  =SUMMON_TYPE_LINK,
	--Summon Value --特定的召唤方式
	SELF  =SUMMON_VALUE_SELF,
	SYM  =SUMMON_VALUE_SYNCHRO_MATERIAL,
}
--Effect Variable
fucg.eff = {
	CRE  = Effect.CreateEffect,
	TYP  = fusf.Set_Constant("Type","etyp"),
	CAT  = fusf.Set_Constant("Category","cat"),
	COD  = fusf.Set_Constant("Code","cod"),
	PRO  = fusf.Set_Constant("Property","pro"),
	VAL  = fusf.Set_Func("Value"),
	CON  = fusf.Set_Func("Condition"),
	COS  = fusf.Set_Func("Cost"),
	TG   = fusf.Set_Func("Target"),
	OP   = fusf.Set_Func("Operation"),
	CLO  = Effect.Clone,
}
function fucg.eff.DES(_fuef,val)
	if not fusf.NotNil(val) then return end
	if type(val) == "table" then
		val = aux.Stringid(table.unpack(val))
	elseif type(val) == "string" then
		if val:match("+") then 
			val = fusf.CutString(val,"+",nil,"DES")
			val = aux.Stringid(tonumber(val[1])<19999999 and (tonumber(val[1])+20000000) or tonumber(val[1]), fusf.NotNil(val[2]) and tonumber(val[2]) or 0)
		else
			val = val:match("%d") and tonumber(val) or fucg.des[val]
		end
	elseif type(val) == "number" then
		val = val<17 and aux.Stringid(_fuef.e:GetOwner():GetOriginalCode(),val) or val
	end
	_fuef.e:SetDescription(val)
end
function fucg.eff.CTL(_fuef,val)
	if not fusf.NotNil(val) then return end
	local ctl = {nil,nil,0}
	if type(val) == "string" then
		for i,v in ipairs(fusf.CutString(val,"+",nil,"CTL")) do
			if v:match("%d") then 
				if i == 1 then ctl[1] = tonumber(v)
				else ctl[2] = ctl[2] + tonumber(v) end
			elseif v:match("m") then
				ctl[2] = _fuef.e:GetOwner():GetOriginalCode()
			elseif v:match("[ODS]") then
				ctl[3] = fucg.ctl[v]
			end
		end
	else
		val = type(val) == "table" and val or { val }
		for i = #val,1,-1 do
			ctl[3] = type(val[i]) == "string" and fucg.ctl[val[i] ] or ctl[3]
			ctl[2] = type(val[i]) == "number" and val[i]>99 and val[i] or ctl[2]
			ctl[1] = type(val[i]) == "number" and val[i]<99 and val[i] or ctl[1]
		end
	end
	if ctl[3] ~= 0 and not ctl[2] then ctl[2] = _fuef.e:GetOwner():GetOriginalCode() end
	ctl[2] = (ctl[2] or 0) + table.remove(ctl)
	ctl[1] = ctl[1] or 1
	_fuef.e:SetCountLimit(table.unpack(ctl))
end
function fucg.eff.RAN(_fuef,val)
	if not fusf.NotNil(val) then return end
	_fuef.e:SetRange(fusf.Loc(val,nil,"RAN"))
end
function fucg.eff.TRAN(_fuef,val)
	if not fusf.NotNil(val) then return end
	_fuef.e:SetTargetRange(fusf.Loc(val,nil,"TRAN"))
end
function fucg.eff.RES(_fuef,_val) -- a + b/b1/b2 + c |1
	if not fusf.NotNil(_val) then return end
	local res,val = type(_val) == "string" and 0 or _val
	if type(_val) == "string" then
		val = fusf.CutString(_val,"|",nil,"RES1")
		for _,V1 in ipairs(fusf.CutString(val[1],"+",nil,"RES2")) do
			V1 = fusf.CutString(V1,"/",nil,"RES3")
			res = res + fucg.res[V1[1] ]
			if V1[2] then
				local _index = "_"..table.remove(V1,1)
				for _,V2 in ipairs(V1) do
					res = res + fucg.res[_index][V2:upper()]
				end
			end
		end
		val = val[2] and tonumber(val[2]) or 1
	end
	_fuef.e:SetReset(res,val)
end
function fucg.eff.LAB(_fuef,val)
	if not fusf.NotNil(val) then return end
	local n = type(val) == "string" and {} or val
	if type(val) == "string" then 
		for _,v in ipairs(fusf.CutString(val,"+",nil,"LAB")) do
			n[#n+1] = tonumber(v)
		end
	end
	_fuef.e:SetLabel(table.unpack(type(n) == "table" and n or { n }))
end
function fucg.eff.OBJ(_fuef,val)
	if not fusf.NotNil(val) then return end
	if type(val) == "table" then val = val[1] end
	_fuef.e:SetLabelObject(val)
end