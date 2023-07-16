if fucg then return end
fucg, fusf = { }, { }
--------------------------------------"Support function"
function fusf.CutString(str,cut)
	str = str..cut
	local list, index, ch = {}, 1, ""
	while index <= #str do
		if string.match(string.sub(str, index, index), cut) then
			list[#list+1] = ch
			ch = ""
		else
			_, index, ch = string.find(str, "^([^"..cut.."]+)", index)
		end
		index = index + 1
	end
	return list
end
function fusf.NotNil(val)   --table or string
	if type(val) == "table" or type(val) == "string" then return #val>0 end
	return val
end
function fusf.DeleteNil(list)
	local setlist = {}
	for _,set in ipairs(list) do
		if not (type(set) == "table" and #set == 1) then
			table.insert(setlist,set)
		end
	end
	return setlist
end
function fusf.Loc(locs,chk)
	local Loc = {0,0}
	for i,l1 in ipairs(fusf.CutString(locs,"+")) do
		for j = 1,#l1 do
			local loc = string.sub(l1,j,j)
			Loc[i] = Loc[i] + fucg.ran[string.upper(loc)]
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
function fusf.Func(func)
	return function(e,val)
		if not (fusf.NotNil(val) and func) then return end
		if type(val) == "string" then val = (string.match(val,"%d") and tonumber(val)) or aux["val"] or val end
		Effect["Set"..func](e,val)
	end
end
function fusf.res(v)
--return Reset
	v = type(v) == "table" and v or { v }
	return table.unpack(v)
end
function fusf.PostFix_Trans(str,val)
	local tTrans, tStack, index = { }, { }, 1
	while index <= #str do
		local ch = string.sub(str, index, index)
		if string.match(ch, "%a") then
			_, index, ch = string.find(str, "^([%a]+)", index)
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
		if tStack[#tStack] == "~" and string.match(ch, "^[%a%)%%]") then
			table.insert(tTrans, table.remove(tStack))
		end
		index = index + 1
	end
	while #tStack > 0 do
		table.insert(tTrans, table.remove(tStack))
	end
	return tTrans
end
function fusf.CutDis(str,dis)
	if Dis == "" then return fusf.CutString(str,",") end
	local ch, Dis = "", fusf.CutString(dis,",")
	for _,S in ipairs(fusf.CutString(str,",")) do
		for i,D in ipairs(Dis) do
			if S == D then 
				table.remove(Dis,i)
				S = ""
			end
		end
		if S ~= "" then ch = ch..","..S end
	end
	return fusf.CutString(string.sub(ch,2),",")
end
function fusf.Value_Trans(val)
	val = type(val) == "table" and val or { val }
	local var = {}
	for i,V in ipairs(val) do
		if type(V) == "string" then
			for _,ch in ipairs(fusf.CutString(V,",")) do
				if ch == "%" then 
					ch = table.remove(val, i + 1)
				elseif ch == "" then
					ch = {}
				end
				table.insert(var, ch)
			end
		else
			table.insert(var, V or {})
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
			if string.match(val, "[%-%~]") then
				tStack[#tStack] = not tStack[#tStack]
			elseif string.match(val, "[%+%/]") then
				CalR = table.remove(tStack)
				CalL = table.remove(tStack)
				local tCal = {
					["+"] = CalL and CalR,
					["/"] = CalL or CalR
				}
				table.insert(tStack, tCal[val])
			else
				table.insert(tStack, func(c,chktable[string.upper(val)]))
			end
		end
		return tStack[#tStack]
	end
end
--------------------------------------"fucg constants"
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
	PS   = EVENT_SUMMON   ,
	SS   = EVENT_SUMMON_SUCCESS   ,
	PSP  = EVENT_SPSUMMON   ,
	SP   = EVENT_SPSUMMON_SUCCESS   ,
	DES  = EVENT_DESTROYED   ,
	--negative
	NEGA = EVENT_CHAIN_NEGATED   ,  --发动无效
	NEGE = EVENT_CHAIN_DISABLED   , --效果无效
	--chain
	CH   = EVENT_CHAINING   ,
}
--property Variable
fucg.pro = { 
	TG  = EFFECT_FLAG_CARD_TARGET   ,
	PTG   = EFFECT_FLAG_PLAYER_TARGET   ,
	CTG = EFFECT_FLAG_CONTINUOUS_TARGET   ,
	DE  = EFFECT_FLAG_DELAY  ,
	SR  = EFFECT_FLAG_SINGLE_RANGE   ,
	HINT  = EFFECT_FLAG_CLIENT_HINT   ,
	O	= EFFECT_FLAG_OATH   ,
	AR  = EFFECT_FLAG_IGNORE_RANGE   ,
	IG  = EFFECT_FLAG_IGNORE_IMMUNE   ,
	CD  = EFFECT_FLAG_CANNOT_DISABLE   ,
	CN  = EFFECT_FLAG_CANNOT_NEGATE   ,
	CC  = EFFECT_FLAG_UNCOPYABLE   ,
	SET   = EFFECT_FLAG_SET_AVAILABLE   ,
	DAM   = EFFECT_FLAG_DAMAGE_STEP  ,
	CAL   = EFFECT_FLAG_DAMAGE_CAL  ,

	OE  = 17408   , --EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE(out effect)
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
	LINK = REASON_LINK  , 
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
	LINK=TYPE_LINK,   --连接
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
--Effect Variable
fucg.eff = {
	CRE  = Effect.CreateEffect,
	TYP  = Effect.SetType,
	VAL  = fusf.Func("Value"),
	CON  = fusf.Func("Condition"),
	COS  = fusf.Func("Cost"),
	TG   = fusf.Func("Target"),
	OP   = fusf.Func("Operation"),
	RES  = function(e,...) if #{...}>0 then Effect.SetReset(e,fusf.res({...})) end end,
	LAB  = Effect.SetLabel,
	OBJ  = Effect.SetLabelObject,
}
function fucg.eff.DES(e,val)
	if not fusf.NotNil(val) then return end
	if type(val) == "table" then
		val = aux.Stringid(table.unpack(val))
	elseif type(val) == "string" then
		val = string.match(val,"%d") and tonumber(val) or fucg.des[val]
	elseif type(val) == "number" then
		val = val<17 and aux.Stringid(e:GetOwner():GetOriginalCode(),val) or val
	end
	e:SetDescription(val)
end
function fucg.eff.CAT(e,val)
	if not fusf.NotNil(val) then return end
	local cat = type(val) == "string" and 0 or val
	if type(val) == "string" then
		for _,V in ipairs(fusf.CutString(val,"+")) do
			cat = cat + fucg.cat[string.upper(V)]
		end
	end
	e:SetCategory(cat)
end
function fucg.eff.COD(e,val)
	local cod = type(val) == "string" and fucg.cod[val] or val
	e:SetCode(cod)
end
function fucg.eff.PRO(e,val)
	if not fusf.NotNil(val) then return end
	local pro = type(val) == "string" and 0 or val
	if type(val) == "string" then
		for _,V in ipairs(fusf.CutString(val,"+")) do
			pro = pro + fucg.pro[string.upper(V)]
		end
	end
	e:SetProperty(pro)
end
function fucg.eff.CTL(e,val)
	if not fusf.NotNil(val) then return end
	local ctl = {nil,nil,0}
	if type(val) == "string" then
		for _,v in ipairs(fusf.CutString(val,"+")) do
			ctl[3] = string.match(v,"[ODS]") and fucg.ctl[v] or ctl[3]
			ctl[2] = string.match(v,"m") and e:GetOwner():GetOriginalCode() or ctl[2]
			ctl[1] = string.match(v,"%d") and tonumber(v) or ctl[1]
		end
	else
		val = type(val) == "table" and val or { val }
		for i = #val,1,-1 do
			ctl[3] = type(val[i]) == "string" and fucg.ctl[val[i] ] or ctl[3]
			ctl[2] = type(val[i]) == "number" and val[i]>99 and val[i] or ctl[2]
			ctl[1] = type(val[i]) == "number" and val[i]<99 and val[i] or ctl[1]
		end
	end
	if ctl[3] ~= 0 and not ctl[2] then ctl[2] = e:GetOwner():GetOriginalCode() end
	ctl[2] = ctl[2] + table.remove(ctl)
	ctl[1] = ctl[1] or 1
	e:SetCountLimit(table.unpack(ctl))
end
function fucg.eff.RAN(e,val)
	if not fusf.NotNil(val) then return end
	e:SetRange(fusf.Loc(val))
end
function fucg.eff.TRAN(e,val)
	if not fusf.NotNil(val) then return end
	e:SetTargetRange(fusf.Loc(val))
end
function fucg.eff.CLO(e)
	if not fusf.NotNil(e) then return end
	if type(e) == "table" then e = e[1] end
	return e:Clone()
end