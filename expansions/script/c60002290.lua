if lanp then return end
lanp, lanf = { }, { }
lanc,lang,lane,lans,lanm = {},{},{},{},{}
--------------------------------------"Support function"
function lanf.CutString(str,cut)
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
function lanf.NotNil(val)   --table or string
	if type(val) == "table" or type(val) == "string" then return #val>0 end
	return val
end
function lanf.DeleteNil(list)
	local setlist = {}
	for _,set in ipairs(list) do
		if not (type(set) == "table" and #set == 1) then
			table.insert(setlist,set)
		end
	end
	return setlist
end
function lanf.Loc(locs,chk)
	local Loc = {0,0}
	for i,l1 in ipairs(lanf.CutString(locs,"+")) do
		for j = 1,#l1 do
			local loc = string.sub(l1,j,j)
			Loc[i] = Loc[i] + lanp.ran[string.upper(loc)]
		end
	end
	if chk then Loc = {Loc[1]} end
	return table.unpack(Loc)
end
function lanf.GetCardTable(c)
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
function lanf.Func(func)
	return function(e,val)
		if not (lanf.NotNil(val) and func) then return end
		if type(val) == "string" then val = (string.match(val,"%d") and tonumber(val)) or aux[val] or val end
		Effect["Set"..func](e,val)
	end
end
function lanf.res(v)
--return Reset
	v = type(v) == "table" and v or { v }
	return table.unpack(v)
end
function lanf.PostFix_Trans(str,val)
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
function lanf.CutDis(str,dis)
	if Dis == "" then return lanf.CutString(str,",") end
	local ch, Dis = "", lanf.CutString(dis,",")
	for _,S in ipairs(lanf.CutString(str,",")) do
		for i,D in ipairs(Dis) do
			if S == D then 
				table.remove(Dis,i)
				S = ""
			end
		end
		if S ~= "" then ch = ch..","..S end
	end
	return lanf.CutString(string.sub(ch,2),",")
end
function lanf.Value_Trans(val)
	val = type(val) == "table" and val or { val }
	local var = {}
	for i,V in ipairs(val) do
		if type(V) == "string" then
			for _,ch in ipairs(lanf.CutString(V,",")) do
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
function lanf.typ(typ)
    if type(typ) == "string" and lanp.type[string.upper(typ)] and not string.match(typ,"%+.") then typ = lanp.type[string.upper(typ)]
    elseif type(typ) == "table" then
        for i=1,#typ do
            if i == 1 then typ = lanp.type[string.upper(typ)]
            else typ = typ + lanp.type[string.upper(typ)] end
        end
    elseif type(typ) == "string" and not lanp.type[string.upper(typ)] and string.find(typ,"%+.") then
        local tr=typ
        local a = { }
        for _,V in ipairs(lanf.CutString(typ,"+")) do
		    a[#a+1] = lanp.type[string.upper(V)]
		end
		local b=0
		for i=1,#a do
		    b=b+a[i]
		end
		typ=b
    end
    return typ
end
function lanf.msg(v)
    return type(v) == "string" and lanp.msg[v] or v
end
function lanf.GetMinMax(val)
    local max,min=nil,nil
    if type(val) == "string" then
        local s=val
        val={}
        for _,V in ipairs(lanf.CutString(s,",")) do
		    val[#val+1] = tonumber(V)
		end
    end
    if type(val) == "table" then
        max=val[1]
        min=val[1]
        for i=2,#val do
            max=val[i]>max and val[i] or max
            min=val[i]<min and val[i] or min
        end
    end
    return min,max
end
--------------------------------------"lanp constants"
--Hint Variable
lanp.des = {
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
lanp.cat = {
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
	DR = CATEGORY_DRAW  ,
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
--type Variable
lanp.type = {
    ["I"] = EFFECT_TYPE_IGNITION     ,
    ["A"] = EFFECT_TYPE_ACTIVATE      ,
    ["S"] = EFFECT_TYPE_SINGLE      ,
    ["F"] = EFFECT_TYPE_FIELD       ,
    ["QO"] = EFFECT_TYPE_QUICK_O        ,
    ["QF"] = EFEFCT_TYPE_QUICK_F        ,
    ["TO"] = EFFECT_TYPE_TRIGGER_O      ,
    ["TF"] = EFFECT_TYPE_TRIGGER_F      ,
    ["C"] = EFFECT_TYPE_CONTINUOUS      ,
    ["G"] = EFFECT_TYPE_GRANT       ,
    ["E"] = EFFECT_TYPE_EQUIP   ,
}
--code Variable
lanp.cod = {
	--other
	["FC"] = EVENT_FREE_CHAIN   ,
	["ADJ"] = EVENT_ADJUST  ,
	--to location
	["TD"] = EVENT_TO_DECK   ,
	["TG"] = EVENT_TO_GRAVE  ,
	["TH"] = EVENT_TO_HAND   ,
	["RE"] = EVENT_REMOVE   ,
	["PS"] = EVENT_SUMMON   ,
	["SS"] = EVENT_SUMMON_SUCCESS   ,
	["PSP"] = EVENT_SPSUMMON   ,
	["SP"] = EVENT_SPSUMMON_SUCCESS   ,
	["DES"] = EVENT_DESTROYED   ,
	--negative
	["NEGA"] = EVENT_CHAIN_NEGATED   ,  --发动无效
	["NEGE"] = EVENT_CHAIN_DISABLED   , --效果无效
}
--property Variable
lanp.pro = { 
	["TG"] = EFFECT_FLAG_CARD_TARGET   ,
	["PTG"] = EFFECT_FLAG_PLAYER_TARGET   ,
	["DE"] = EFFECT_FLAG_DELAY  ,
	["SR"] = EFFECT_FLAG_SINGLE_RANGE   ,
	["HINT"] = EFFECT_FLAG_CLIENT_HINT   ,
	["OA"] = EFFECT_FLAG_OATH   ,
	["AR"] = EFFECT_FLAG_IGNORE_RANGE   ,
	["IG"] = EFFECT_FLAG_IGNORE_IMMUNE   ,
	["CD"] = EFFECT_FLAG_CANNOT_DISABLE   ,
	["CN"] = EFFECT_FLAG_CANNOT_NEGATE   ,
	["SET"] = EFFECT_FLAG_SET_AVAILABLE   ,
	["OE"] = 17408   , --EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE(out effect)
	["DAM"] = EFFECT_FLAG_DAMAGE_STEP  ,
	["CAL"] = EFFECT_FLAG_DAMAGE_CAL  ,
}
--Hint Varuable
lanp.msg = {
    --hint
    ["E"] = HINT_EVENT      ,
    ["M"] = HINT_MESSAGE   ,
    ["S"] = HINT_SELECTMSG     ,
    ["OP"] = HINT_OPSELECTED        ,
    ["F"] = HINT_EFFECT     ,
    ["R"] = HINT_RACE   ,
    ["A"] = HINT_ATTRIB     ,
    ["O"] = HINT_CODE   ,
    ["N"] = HINT_NUMBER     ,
    ["C"] = HINT_CARD   ,
    --hintmsg
    ["RE"] = HINTMSG_RELEASE        ,
    ["DC"] = HINTMSG_DISCSRD    ,
    ["DES"] = HINTMSG_DESTROY   ,
    ["RM"] = HINTMSG_REMOVE ,
    ["TG"] = HINTMSG_TOGRAVE    ,
    ["RTH"] = HINTMSG_RTOHAND   ,
    ["ATH"] = HINTMSG_ATOHAND   ,
    ["TD"] = HINTMSG_TODECK ,
    ["SS"] = HINTMSG_SUMMON ,
    ["SP"] = HINTMSG_SPSUMMON   ,
    ["ST"] = HINTMSG_SET    ,
    ["FM"] = HINTMSG_FMATERIAL  ,
    ["SM"] = HINTMSG_SMATERIAL  ,
    ["XM"] = HINTMSG_XMATERIAL  ,
    ["LM"] = HINTMSG_LMATERIAL  ,
    ["FU"] = HINTMSG_FACEUP ,
    ["FD"] = HINTMSG_FACEDOWN   ,
    ["ATK"] = HINTMSG_ATTACK    ,
    ["DEF"] = HINTMSG_DEFENSE    ,
    ["EQ"] = HINTMSG_EQUIP      ,
    ["RX"] = HINTMSG_REMOVEXYZ  ,
    ["CT"] = HINTMSG_CONTRAL    ,
    ["DR"] = HINTMSG_DESREPLACE     ,
    ["UATK"] = HINTMSG_FACEUPATTACK ,
    ["UDEF"] = HINTMSG_FACEUPDEFENSE    ,
    ["DATK"] = HINTMSG_FACEDOWNATTACK ,
    ["DDEF"] = HINTMSG_FACEDOWNDEFENCE  ,
    ["CF"] = HINTMSG_CONFIRM    ,
    ["TF"] = HINTMSG_TOFIELD    ,
    ["PS"] = HINTMSG_POSCHANGE  ,
    ["SF"] = HINTMSG_SELF       ,
    ["PP"] = HINTMSG_OPPO   ,
    ["TB"] = HINTMSG_TRIBUTE    ,
    ["DF"] = HINTMSG_DEATTACHFROM   ,
    ["ATAG"] = HINTMSG_ATTACKTATGET ,
    ["MF"] = HINTMSG_EFFECT     ,
    ["TAG"] = HINTMSG_TARGET    ,
    ["CN"] = HINTMSG_COIN   ,
    ["DI"] = HINTMSG_DICE   ,
    ["CY"] = HINTMSG_CARDTYPE  ,
    ["ON"] = HINTMSG_OPTION ,
    ["REF"] = HINTMSG_RESOLVEEFFECT ,
    ["SEL"] = HINTMSG_SELECT    ,
    ["POS"] = HINTMSG_POSITION  ,
    ["MA"] = HINTMSG_ATTRIBUTE ,
    ["MR"] = HINTMSG_RACE   ,
    ["MO"] = HINTMSG_CODE       ,
    ["REC"] = HINTMSG_RESOLVECARD   ,
    ["ZO"] = HINTMSG_ZONE       ,
    ["TZ"] = HINTMSG_TOZONE     ,
}
--Location Variable
lanp.ran = {
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
	["N"] = LOCATION_ONFIELD,
	["A"] = 0xff 
}
--Phase Variable
lanp.pha = {
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
--count limit Variable
lanp.ctl = {
	O = EFFECT_COUNT_CODE_OATH  ,  --发动次数
	D = EFFECT_COUNT_CODE_DUEL  ,  --决斗次数
	S = EFFECT_COUNT_CODE_SINGLE  ,  --公共次数
}
--reason Variable
lanp.rea = {
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
	RU = REASON_RULE    ,
	DR = REASON_DRAW    ,
	COS = REASON_COST  ,  --用於代價或無法支付代價而破壞
	REP = REASON_REPLACE  ,  --代替
	TEM = REASON_TEMPORARY  ,  --暂时
	ADJ = REASON_ADJUST  ,  --调整（御前试合）
}
--position Variable
lanp.pos = {
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
lanp.att = {
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
lanp.rac = {
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
lanp.typ = {
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
lanp.eff = {
	CRE  = Effect.CreateEffect,
	GLE   = Effect.GlobalEffect,
	TYP  = Effect.SetType,
	VAL  = lanf.Func("Value"),
	CON  = lanf.Func("Condition"),
	COS  = lanf.Func("Cost"),
	TG   = lanf.Func("Target"),
	OP   = lanf.Func("Operation"),
	RES  = function(e,...) if #{...}>0 then Effect.SetReset(e,lanf.res({...})) end end,
	LAB  = Effect.SetLabel,
}
function lanp.eff.DES(e,...)
	local val = {...}
	if not lanf.NotNil(val) then return end
	val = #val==1 and val[1] or val
	if type(val) == "table" then
		val = aux.Stringid(table.unpack(val))
	elseif type(val) == "string" then
		val = lanp.des[val]
	elseif type(val) == "number" then
		val = val<17 and aux.Stringid(e:GetOwner():GetOriginalCode(),val) or val
	end
	Effect.SetDescription(e,val)
end
function lanp.eff.CTL(e,val)
	if not lanf.NotNil(val) then return end
	local ctl = {nil,nil,0}
	if type(val) == "string" then
		for _,v in ipairs(lanf.CutString(val,"+","CTL")) do
			ctl[3] = string.match(v,"[ODS]") and lanp.ctl[v] or ctl[3]
			ctl[2] = string.match(v,"m") and e:GetOwner():GetOriginalCode() or ctl[2]
			ctl[1] = string.match(v,"%d") and tonumber(v) or ctl[1]
		end
	else
		val = type(val) == "table" and val or { val }
		for i = #val,1,-1 do
			ctl[3] = type(val[i]) == "string" and lanp.ctl[val[i] ] or ctl[3]
			ctl[2] = type(val[i]) == "number" and val[i]>99 and val[i] or ctl[2]
			ctl[1] = type(val[i]) == "number" and val[i]<99 and val[i] or ctl[1]
		end
	end
	if ctl[3] ~= 0 and not ctl[2] then ctl[2] = e:GetOwner():GetOriginalCode() end
	ctl[2] = (ctl[2] or 0) + table.remove(ctl)
	ctl[1] = ctl[1] or 1
	e:SetCountLimit(table.unpack(ctl))
end
function lanp.eff.CAT(e,val)
	if not lanf.NotNil(val) then return end
	local cat = type(val) == "string" and 0 or val
	if type(val) == "string" then
		for _,V in ipairs(lanf.CutString(val,"+")) do
			cat = cat + lanp.cat[string.upper(V)]
		end
	end
	Effect.SetCategory(e,cat)
end
function lanp.eff.COD(e,val)
	local cod = type(val) == "string" and lanp.cod[val] or val
	Effect.SetCode(e,cod)
end
function lanp.eff.PRO(e,val)
	if not lanf.NotNil(val) then return end
	local pro = type(val) == "string" and 0 or val
	if type(val) == "string" then
		for _,V in ipairs(lanf.CutString(val,"+")) do
			pro = pro + lanp.pro[string.upper(V)]
		end
	end
	Effect.SetProperty(e,pro)
end
function lanp.eff.RAN(e,val)
	if not lanf.NotNil(val) then return end
	e:SetRange(lanf.Loc(val,nil,"RAN"))
end
function lanp.eff.TRAN(e,val)
	if not lanf.NotNil(val) then return end
	e:SetTargetRange(lanf.Loc(val,nil,"TRAN"))
end
function lanp.eff.OBJ(e,val)
	if not lanf.NotNil(val) then return end
	if type(val) == "table" then val = val[1] end
	e:SetLabelObject(val)
end
function lanp.eff.CLO(e)
	if not lanf.NotNil(e) then return end
	if type(e) == "table" then e = e[1] end
	return e:Clone()
end
----------------------------lanp-----------------------------------
function lanp.OP(mat_operation,tg,operation_params)
    for i=1,#operation_params do
        if type(operation_params[i]) == "string" then 
            local az=operation_params[i]
            operation_params[i] = 0
            for _,V in ipairs(lanf.CutString(az,"+")) do
			    operation_params[i] = operation_params[i] + lanp.rea[string.upper(V)]
			end
		end
    end
    return mat_operation(tg,table.unpack(operation_params))
end
function lanp.CC(str,name)
    local offset=self_code<100000000 and 1 or 100
    if type(str) == "string" then
	    self_table.setcard = { }
	    for _,V in ipairs(lanf.CutString(str,"+")) do
            local a=self_table.setcard
            a[#a+1] = V
			lans[self_code] = a
		end  
	end
	if type(name) == "string" then
	    self_table.name = name
	    lanm[self_code] = self_table.name
	end
	return self_table,self_code,offset
end
function lanp.RFE(py,cod,res,pro,ct,lab,desc)
    if type(py) == "Card" then Debug.Message("okk") end
    if not py then py = 0 end
    if not res then res=0 end
    if not pro then pro=0
    elseif type(pro) == "string" then 
        local val = 0
        for _,V in ipairs(lanf.CutString(pro,"+")) do
		    val = val + lanp.pro[string.upper(V)]
        end
        pro=val
    end
    if not ct then ct1 =1 end
    if not lab then lab = 0 end
    if desc and type(desc) == "table" then desc=aux.Stringid(desc[1],desc[2]) end
    if type(py) == "number" then return Duel.RegisterFlagEffect(py,cod,res,pro,ct,lab)
    else return py:RegisterFlagEffect(cod,res,pro,ct,lab,desc) end
end
function lanp.YN(tp,m,desc)
    local az=nil
    if desc then az=aux.Stringid(m,desc) 
    else az=m end
    return Duel.SelectYesNo(tp,az)
end
function lanp.SO(cha,cat,g,ct,py,loc)
    local val=loc
    if type(val) == "string" then
        loc=0
		for _,V in ipairs(lanf.CutString(val,"+")) do
			loc = loc + lanp.ran[string.upper(V)]
		end
	end
    return Duel.SetOperationInfo(cha,lanp.cat[cat],g,ct,py,loc)
end
function lanp.H(typ,py,desc)
    typ= lanf.msg(typ)
    if typ == lanp.msg["S"] then desc = lanf.msg(desc) end
    return Duel.Hint(typ,py,desc)
end
function lanp.SelectOption(a,b,c,d,tp)
    local off=1
    local ops={}
    local opval={}
    if type(c) == "table" then c=aux.Stringid(c[1],c[2]) end
    if type(d) == "table" then d=aux.Stringid(d[1],d[2]) end
    if a then
    ops[off]=c
    opval[off]=0
    off=off+1
    end
    if b then
	    ops[off]=d
	    opval[off]=1
	    off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	return sel
end
function lanp.U(v,...)
    local c
    if v=="设置卡" then c={lanp.CC(...)}
    elseif v=="标识" then c={lanp.RFE(...)}
    elseif v=="连锁信息" then c={lanp.SO(...)}
    elseif v=="效果处理" then c={lanp.OP(...)} 
    elseif v=="是否" then c={lanp.YN(...)}
    elseif v=="提示" then c={lanp.H(...)}
    elseif v=="选择" then c={lanp.SelectOption(...)}
    end
    return table.unpack(c)
end
----------------------------lanc-----------------------------------
function lanc.Filter(c,f,...)
	local v = {...}
	v = #v==1 and v[1] or v
	if not c then Debug.Message(f) end
	return lang.Filter(Group.FromCards(c),f,v,1)
end
function lanc.Compare(c,f,n,meth,...)
	if type(f) == "string" then f=lanc[f] or Card[f] or aux[f] end
	local v = {...}
	v = type(v[1]) =="table" and #v==1 and v[1] or v
	if meth == "A" then
		return f(c,table.unpack(v))>=n
	elseif meth == "B" then
		return f(c,table.unpack(v))<=n
	end
	return f(c,table.unpack(v))==n
end
function lanc.TgChk(c,e)
	return c:IsCanBeEffectTarget(e)
end
function lanc.GChk(c)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function lanc.Not(c,val)
	if aux.GetValueType(val) == "Card" then
		return c ~= val
	elseif aux.GetValueType(val) == "Group" then
		return not val:IsContains(c)
	elseif aux.GetValueType(val) == "function" then
		return not val(c)
	end
	return false
end
function lanc.IsSet(c,set)
	if type(set) == "number" then return c:IsSetCard(set) end
	for _,Set in ipairs(lanf.CutString(set,"/")) do
		Set=tonumber(Set,16)
		if Set and c:IsSetCard(Set) then return true end
	end
	return false
end
function lanc.GetSeries(mt)
    if aux.GetValueType(mt) == "Card" then mt=lanf.GetMetaTable(mt)
    elseif type(mt)=="number" then mt=_G["c"..mt] end
    local tb={}
    for i=1,#mt do
        local a=mt[i]
        if a.setcard then
            for b=1,#a.setcard do
                tb[#tb+1]=a.setcard[b]
            end
        end
    end
    return tb
end
function lanc.GetName(mt)
    if aux.GetValueType(mt) == "Card" then mt=lanf.GetMetaTable(mt)
    elseif type(mt)=="number" then mt=_G["c"..mt] end
    local nm={}
    for i=1,#mt do
        local a=mt[i]
        if a.name then
            nm[#nm+1]=a.name
        end
    end
    return nm
end
function lanc.IsSeries(c,str,ck)
    local mt=nil
    if type(ck) == "string" and ck == "Original" then 
        mt = lanf.getmetatable(c)
        local ser=lanc.GetSeries(mt)
        for i=1,#ser do
            if ser[i] and ser[i]==str then return true end
        end
    else
        local ser=lanc.GetSeries(c)
        for i=1,#ser do
            if ser[i] and ser[i]==str then return true end
        end
    end
    return false
end
Card.IsSeries = function(c,v,ck) return lanc.IsSeries(c,v,ck) end
function lanc.IsName(c,str,ck)
    local mt=nil
    local check=false
    if type(ck) == "string" and ck == "Original" then 
        mt = lanf.getmetatable(c)
        if mt.name and mt.name == str then return true end
    else 
        nm=lanc.GetName(c)
        for i=1,#nm do
            if nm[i] and nm[i] == str then return true end
        end
    end
    return false
end
function lanc.AbleTo(c,loc)
	local func = {
		["H"] = "Hand"   ,
		["D"] = "Deck"   ,
		["G"] = "Grave"  ,
		["R"] = "Remove",
		["E"] = "Extra"  ,
	}
	local iscos = string.sub(loc,1,1) == "*"
	if iscos then loc = string.sub(loc,2) end
	func = "IsAbleTo"..func[loc]
	if iscos then func = func.."AsCost" end
	return Card[func](c)
end
function lanc.CanSp(c,e,typ,tp,nochk,nolimit,pos,totp,zone)
	return c:IsCanBeSpecialSummoned(e, typ, tp, nochk or false, nolimit or false, pos or POS_FACEUP, totp or tp,zone or 0xff)
end
function lanc.IsCod(c,cod)
	if type(cod) == "string" then cod = tonumber(cod) end
	return c:IsCode(cod)
end
function lanc.IsLoc(c,loc,ex)
    local az,a,b=nil,"Is","Location"
    if ex then az=a..ex..b else az=a..b end
	return Card[az](c,lanf.Loc(loc))
end
function lanc.CheckConstantValue(func,chktable)
	return function(c,cons)
		if cons and type(cons) ~= "string" then return func(c,cons) end
		local Cons, tStack = lanf.PostFix_Trans(cons), { }
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
function lanc.GetNumberCardInGroup(g,ct)
    local tc
    for i=1,ct do
        if i==1 then tc=g:GetFirst()
        else tc=g:GetNext() end
    end
    return tc
end
function lanc.IsOnGroup(c,g)
    return g:IsContains(c)
end
function lanc.IsHasVariableInGroup(c,g,f)
    for i=1,#g do
        local tc=lanc.GetNumberCardInGroup(g,i)
        if Group.FromCards(c,tc):GetClassCount(f)<=1 then return false end
    end
    return true
end
lanc.IsRea = lanc.CheckConstantValue(function(c,v) return c:IsReason(v) end,lanp.rea)
lanc.IsTyp = lanc.CheckConstantValue(function(c,v) return c:GetType()&v==v end,lanp.typ)
lanc.IsAtt = lanc.CheckConstantValue(function(c,v) return c:GetAttribute()&v==v end,lanp.att)
lanc.IsRac = lanc.CheckConstantValue(function(c,v) return c:GetRace()&v==v end,lanp.rac)
lanc.IsPos = lanc.CheckConstantValue(function(c,v) return c:IsPosition(v) end,lanp.pos)
lanc.IsNSeries = function(c,v,ck) return not lanc.IsSeries(c,v,ck) end
lanc.IsNName = function(c,v,ck) return not lanc.IsName(c,v,ck) end
----------------------------lang-----------------------------------
function lang.Get(p,loc)
    local locc=nil
    if type(loc)=="string" then locc=0
    elseif type(loc)=="table" then locc=lanf.Loc(loc[2]) loc=loc[1] end
	return Duel.GetFieldGroup(p,lanf.Loc(loc),locc)
end
function lang.Filter(g,f,v,n)
	local func, tStack, index = { }, { }, 1
	v = type(v) == "table" and v or { v }
	func = type(f) == "string" and lanf.PostFix_Trans(f,v) or { f }
	local var = lanf.Value_Trans(v)
	if #func==1 then
		if type(func[1]) == "string" then func[1] = lanc[func[1] ] or Card[func[1] ] or aux[func[1] ] end
		g = g:Filter(func[1],nil,table.unpack(var))
	else
		local CalL, CalR
		for _,val in ipairs(func) do
			if val == "~" then
				CalR = g - table.remove(tStack)
				table.insert(tStack, CalR)
			elseif type(val) == "string" and #val == 1 then
				CalR = table.remove(tStack)
				CalL = table.remove(tStack)
				local tCalc = {
					["+"] = CalL & CalR,
					["-"] = CalL - CalR,
					["/"] = CalL + CalR
				}
				table.insert(tStack, tCalc[val])
			else
				if type(val) == "string" then val = lanc[val] or Card[val] or aux[val] end
				local V = table.remove(var,1)
				V = V and (type(V) =="table" and V or {V}) or { }
				table.insert(tStack, g:Filter(val,nil,table.unpack(V)))
			end
		end
		g = table.remove(tStack)
	end
	if n then return #g>=n end
	return g
end
function lang.GetFilter(p,loc,f,v,n)
	return lang.Filter(lang.Get(p,loc),f,v,n)
end
function lang.SelectFilter(p,loc,f,v,c,min,max,sp)
    c = c or nil
	min=min or 1
	return lang.GetFilter(p,loc,f,v):Select(sp or p,min,max or min,c)
end
function lang.RandomSelectFilter(p,loc,f,v,c,ct,sp)
    ct = ct or 1
	return lang.GetFilter(p,loc,f,v):RandomSelect(sp or p,ct,c)
end
function lang.SelectTg(p,loc,f,v,c,min,max,sp)
	local g=lang.SelectFilter(p,loc,f,v,c,min,max,sp)
	Duel.SetTargetCard(g)
	return g
end
----------------------------lane-----------------------------------
function lane.Creat(owner,handler,...)
	local e = lane.Set(lanp.eff.CRE(lanf.GetCardTable(owner)[1]),...)
	if handler then lane.Register(e,handler) end
	return e
end
function lane.Global(owner,...)
    local ge = lane.Set(lanp.eff.GLE(lanf.GetCardTable(owner)[1]),...)
    lane.Register(ge,0)
    return ge
end
function lane.Clone(effect,handler,...)
	local e = lane.Set(lanp.eff.CLO(effect),...)
	if handler then lane.Register(e,handler) end
	return e
end
function lane.Set(e,...)
	e = type(e) == "table" and e or { e }
	local setlist = {...}
	if #setlist == 0 then return table.unpack(e) end
	if type(setlist[1]) ~= "table" then setlist = {setlist} end
	for _,E in ipairs(e) do
		for _,set in ipairs(setlist) do
			local f = type(set[1]) == "string" and lanp.eff[set[1] ] or set[1]
			table.remove(set,1)
			f(E,table.unpack(set))
		end
	end
	return e
end
function lane.Register(e,handler)
	handler = type(handler) == "table" and handler or { handler }
	local Ignore = handler[2] or false
	local Handler = type(handler[1]) == "number" and handler[1] or lanf.GetCardTable(handler[1])
	for _,E in ipairs(type(e) == "table" and e or {e}) do
		if type(Handler) == "number" then
			Duel.RegisterEffect(E,Handler)
		else
			for _,C in ipairs(Handler) do
				C:RegisterEffect(E,Ignore)
			end
		end
	end
end
--------------------------------------------------------------------------"Effect_Base"
--Action Effect
function lane.Act(typ,dis)
    local typ = lanf.typ(typ)
	return function(c,rc,...)
		local v, var = lanf.Value_Trans({...}), { }
		for i,val in ipairs(lanf.CutDis("DES,CAT,COD,PRO,RAN,CTL,CON,COS,TG,OP,RES,LAB,OBJ",dis)) do
			if val == "COD" then
				var[#var + 1] = { val , lanf.NotNil(v[i]) and v[i] or "FC" }
			elseif lanf.NotNil(v[i]) then
				var[#var + 1] = { val , v[i] }
			end
		end
		return lane.Creat(c,rc,{"TYP",typ},table.unpack(var))
	end
end  
--NoAction Effect
function lane.NoAct(typ,dis)
	return function(c,rc,...)
		local v, var = lanf.Value_Trans({...}), { }
		for i,val in ipairs(lanf.CutDis("DES,COD,PRO,RAN,TRAN,VAL,CTL,CON,TG,OP,RES,LAB,OBJ",dis)) do
			if lanf.NotNil(v[i]) then
				var[#var + 1] = { val , v[i] }
			end
		end
		return lane.Creat(c,rc,{"TYP",typ},table.unpack(var))
	end
end 
--Global Effect
function lane.Glo(typ,dis)
	return function(c,...)
		local v, var = lanf.Value_Trans({...}), { }
		for i,val in ipairs(lanf.CutDis("COD,PRO,CON,TG,OP,LAB,OBJ",dis)) do
			if lanf.NotNil(v[i]) then
				var[#var + 1] = { val , v[i] }
			end
		end
		return lane.Global(c,{"TYP",typ},table.unpack(var))
	end
end
--Cost
function lane.paycost(ct)
    return function(e,tp,eg,ep,ev,re,r,rp,chk)
	    if chk==0 then return Duel.CheckLPCost(tp,ct) end
	    Duel.PayLPCost(tp,ct)
	end
end
function lane.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--Con
function lane.sptyp_con(sptyp)
    return	function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
	    return lanc.Filter(c,"IsSummonType",sptyp)
	end
end
lane.B_A = lane.Act(lanf.typ("A"),"RAN")
lane.A   = function(c,rc,cod) return lane.B_A(c,rc or c,",",cod) end
lane.I   = lane.Act(lanf.typ("I"),"")
lane.QO  = lane.Act(lanf.typ("QO"),"")
lane.QF  = lane.Act(lanf.typ("QF"),"")
lane.FTO = lane.Act(lanf.typ("F+TO"),"")
lane.FTF = lane.Act(lanf.typ("F+TF"),"")
lane.STO = lane.Act(lanf.typ("S+TO"),"RAN")
lane.STF = lane.Act(lanf.typ("S+TF"),"RAN")
lane.S   = lane.NoAct(lanf.typ("S"),"TRAN,TG")
lane.SC  = lane.NoAct(lanf.typ("S+C"),"RAN,TRAN,VAL,TG")
lane.F   = lane.NoAct(lanf.typ("F"),"")
lane.FC  = lane.NoAct(lanf.typ("F+C"),"TRAN,VAL,TG")
lane.FG  = lane.NoAct(lanf.typ("F+G"),"DES,COD,PRO,VAL,CTL,TG,OP")
lane.E   = lane.NoAct(lanf.typ("E"),"DES,RAN,TRAN,CTL,TG,OP")
lane.EC  = lane.NoAct(lanf.typ("S+C"),"DES,PRO,RAN,TRAN,VAL,CTL")
lane.GLO1 = lane.Glo(lanf.typ("F+C"),"PRO,TG,LAB,OBJ")
----------------------------lanf-----------------------------------
lanp.loaded_metatable_list=lanp.loaded_metatable_list or {}
function lanf.getmetatable(c)
    local code=c:GetOriginalCode()
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=lanp.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			lanp.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function lanf.GetMetaTable(c)
    local code={c:GetCode()}
    local m={ }
    local mt={ }
    for i=1,#code do
	    mt[i]=_G["c"..code[i]]
	    lanp.loaded_metatable_list[code[i]]=mt[i]
	    m[i]=lanp.loaded_metatable_list[code[i]]
	end
	return mt
end

dusk = {}
dusk.begin = {}
dusk.Pe = function(c,rc) return lane.S(c,rc,"",EFFECT_SELF_DESTROY,"SR,P,,",dusk.con3,"") end
function dusk.con1(e,tp,eg,ep,ev,re,r,rp)
    return lang.Get(tp,"E"):GetCount()>=15 and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function dusk.con2(e,tp,eg,ep,ev,re,r,rp)
    return dusk.con1(e,tp,eg,ep,ev,re,r,rp) and not lang.GetFilter(tp,"N","IsNSeries+IsFaceup","黄昏",1)
end
function dusk.con3(e,tp,eg,ep,ev,re,r,rp)
    return lang.Get(tp,"E"):GetCount()<15 
end