if fucg then return end
fucg = { }
fucf = { }  --"Card function"
fuef = { }  --"Effect function"
fusf = { }  --"Support function"
fugf = { }  --"Group function"
--Hint Variable
fucg.des = {
	["TH"] = 1190   ,  --加入手卡
	["TG"] = 1191   ,  --送去墓地
	["RE"] = 1192   ,  --除外
	["SP"] = 1152   ,  --特殊召唤
	["DES"] = 20099999*16   ,  --破坏
}
--category Variable
fucg.cat = {
	["SH"] = 0x20008	, --CATEGORY_SEARCH+CATEGORY_TOHAND
	--
	["S"] = CATEGORY_SUMMON   ,
	["SP"] = CATEGORY_SPECIAL_SUMMON	,
	["TD"] = CATEGORY_TODECK   ,
	["TG"] = CATEGORY_TOGRAVE  ,
	["TH"] = CATEGORY_TOHAND   ,
	["RE"] = CATEGORY_TOREMOVE   ,
	["DES"]= CATEGORY_DESTROY ,
}
--code Variable
fucg.cod = {
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
}
--property Variable
fucg.pro = {
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
	["DP"] = PHASE_DRAW   ,  --抽卡阶段
	["SP"] = PHASE_STANDBY  ,  --准备阶段
	["M1"] = PHASE_MAIN1		,  --主要阶段1
	["BPS"]= PHASE_BATTLE_START ,  --战斗阶段开始
	["BP"] = PHASE_BATTLE_STEP  ,  --战斗步驟
	["DA"] = PHASE_DAMAGE   ,  --伤害步驟
	["DC"] = PHASE_DAMAGE_CAL   ,  --伤害计算时
	["BPE"]= PHASE_BATTLE   ,  --战斗阶段結束
	["M2"] = PHASE_MAIN2		,  --主要阶段2
	["ED"] = PHASE_END  ,  --结束阶段
}
--count limit Variable
fucg.ctl = {
	O = EFFECT_COUNT_CODE_OATH  ,  --发动次数
	D = EFFECT_COUNT_CODE_DUEL  ,  --决斗次数
	S = EFFECT_COUNT_CODE_SINGLE  ,  --公共次数
}
--reason Variable
fucg.rea = {
	["DES"] = REASON_DESTROY  ,  --破坏
	["MAT"] = REASON_MATERIAL  ,  --作为融合/同调/超量素材或用於儀式/升級召喚
	["REL"] = REASON_RELEASE  ,  --解放
	["BAT"] = REASON_BATTLE  ,  --战斗破坏
	["EFF"] = REASON_EFFECT  ,  --战斗破坏
	["COS"] = REASON_COST  ,  --用於代價或無法支付代價而破壞
	["REP"] = REASON_REPLACE  ,  --代替
	["FU"] = REASON_FUSION  ,  --用於融合召喚
	["SY"] = REASON_SYNCHRO  ,  --用於同调召喚
	["RI"] = REASON_RITUAL  ,  --用於仪式召喚
	["XYZ"] = REASON_XYZ  ,  --用於超量召喚
}
--Card type Variable
fucg.typ = {
	["M"]   =TYPE_MONSTER,   --怪兽卡
	["S"]   =TYPE_SPELL,   --魔法卡
	["T"]   =TYPE_TRAP,   --陷阱卡
	["NO"]  =TYPE_NORMAL,   --通常怪兽
	["EF"]  =TYPE_EFFECT,   --效果
	["FU"]  =TYPE_FUSION,   --融合
	["RI"]  =TYPE_RITUAL,   --仪式
	["TR"]  =TYPE_TRAPMONSTER,   --陷阱怪兽
	["SPI"] =TYPE_SPIRIT,   --灵魂
	["UN"]  =TYPE_UNION,   --同盟
	["DU"]  =TYPE_DUAL,   --二重
	["TU"]  =TYPE_TUNER,   --调整
	["SY"]  =TYPE_SYNCHRO,   --同调
	["TO"]  =TYPE_TOKEN,   --衍生物
	["QU"]  =TYPE_QUICKPLAY,  --速攻
	["CON"] =TYPE_CONTINUOUS,   --永续
	["EQ"]  =TYPE_EQUIP,   --装备
	["FI"]  =TYPE_FIELD,   --场地
	["COU"] =TYPE_COUNTER,   --反击
	["FL"]  =TYPE_FLIP,   --翻转
	["XY"]  =TYPE_XYZ,   --超量
	["PE"]  =TYPE_PENDULUM,  --灵摆
	["SP"]  =TYPE_SPSUMMON,  --特殊召唤
	["LI"]  =TYPE_LINK,   --连接
}
--Effect Variable
fucg.eff = {
	CRE   = Effect.CreateEffect,
	DES   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetDescription(fusf.des(e,{...})) end end,
	CAT   = function(e,v) if v then Effect.SetCategory(e,fusf.cat(v)) end end,
	TYP   = Effect.SetType,
	COD   = function(e,v) if v then Effect.SetCode(e,fusf.cod(v)) end end,
	CTL   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetCountLimit(fusf.ctl(e,{...})) end end,
	PRO   = function(e,s,v) if s then Effect.SetProperty(e,fusf.pro(s,v)) end end,
	RAN   = function(e,v) if v then Effect.SetRange(e,fusf.Loc(v,1)) end end,
	CON   = Effect.SetCondition,
	COS   = Effect.SetCost,
	TG  = Effect.SetTarget,
	OP  = Effect.SetOperation,
	VAL   = Effect.SetValue,
	RES   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetReset(e,fusf.res({...})) end end,
	TRAN  = function(e,v) if v then Effect.SetTargetRange(e,fusf.Loc(v)) end end,
	LAB   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetLabel(e,...) end end,
	LABOBJ= Effect.SetLabelObject,
	CLO   = Effect.Clone,
}
--------------------------------------"Card function"
function fucf.Filter(c,f,...)
	local v = {...}
	v = #v==1 and v[1] or v
	return fugf.Filter(Group.FromCards(c),f,v,nil,1)
end
function fucf.Compare(c,f,n,meth,...)
	if type(f) == "string" then f=fucf[f] or Card[f] or aux[f] end
	local v = {...}
	v = type(v[1]) =="table" and #v==1 and v[1] or v
	if meth == "A" then
		return f(c,table.unpack(v))>=n
	elseif meth == "B" then
		return f(c,table.unpack(v))<=n
	end
	return f(c,table.unpack(v))==n
end
function fucf.IsReason(c,rea)
	local rea={}
	if rea and type(rea) ~= "string" then return c:IsReason(rea) end
	for i,r1 in ipairs(fusf.CutString(rea,"-")) do
		for _,r2 in ipairs(fusf.CutString(r1,"+")) do
			rea[i] = rea[i] + fucg.rea[string.upper(r2)]
		end
	end
	return (not rea[1] or c:IsReason(rea[1])) and not (rea[2] and c:IsReason(REASON_REPLACE))
end
function fucf.IsLoc(c,loc)
	return c:IsLocation(fusf.Loc(loc))
end
function fucf.TgChk(c,e)
	return c:IsCanBeEffectTarget(e)
end
function fucf.GChk(c)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function fucf.AbleTo(c,loc)
	local func = {
		["H"] = "Hand"   ,
		["D"] = "Deck"   ,
		["G"] = "Grave"  ,
		["R"] = "Remove",
		["E"] = "Extra"  ,
	}
	local iscos = string.sub(loc,1,1) == "+"
	if iscos then loc = string.sub(loc,2) end
	func = "IsAbleTo"..func[loc]
	if iscos then func = func.."AsCost" end
	return Card[func](c)
end
function fucf.IsTyp(c,typ)
	if typ and type(typ) ~= "string" then return c:GetType()&typ==typ end
	for _,t1 in ipairs(fusf.CutString(typ,"|")) do
		local Typ=0
		for _,t2 in ipairs(fusf.CutString(t1,"+")) do
			Typ = Typ + fucg.typ[string.upper(t2)]
		end
		if Typ>0 and c:GetType()&Typ==Typ then return true end
	end
	return false
end
--------------------------------------"Group function"
function fugf.Get(p,loc)
	return Duel.GetFieldGroup(p,fusf.Loc(loc))
end
function fugf.Filter(g,f,v,c,n)
	if c then g = g:Filter(aux.TRUE,c) end
	local func = {}
	f = type(f) =="table" and f or { f }
	v = type(v) =="table" and v or { v }
	for _,F in ipairs(f) do
		if type(F) == "string" then
			for i,f1 in ipairs(fusf.CutString(F,"-")) do
				for j,f2 in ipairs(fusf.CutString(f1,"+")) do
					func[#func+1] = fucf[f2] or Card[f2] or aux[f2]
					if i>1 and j==1 then func[#func] = aux.NOT(func[#func]) end
				end
			end
		else
			func[#func+1] = F
		end
	end
	if #func==1 then 
		g = g:Filter(func[1],nil,table.unpack(v))
	else
		for i,F in pairs(func) do
			local V = v[i] and (type(v[i]) =="table" and v[i] or {v[i]}) or {}
			g = g:Filter(F,nil,table.unpack(V))
		end
	end
	if n then return #g >= n end
	return g
end
function fugf.GetFilter(p,loc,f,v,c,n)
	return fugf.Filter(fugf.Get(p,loc),f,v,c,n)
end
function fugf.SelectFilter(p,loc,f,v,c,min,max,sp)
	return fugf.GetFilter(p,loc,f,v):Select(sp or p,min,max or min,c)
end
function fugf.SelectTg(p,loc,f,v,c,min,max,sp)
	local g=fugf.GetFilter(p,loc,f,v):Select(sp or p,min,max or min,c)
	Duel.SetTargetCard(g)
	return g
end
--------------------------------------"Support function"
function fusf.CutString(s,cut)
	local slist = {}
	local mark=1
	while mark<=string.len(s) do
		local chk = {string.find(s,cut,mark)}
		local str = string.sub(s,mark,chk[1] and chk[1]-1 or nil)
		slist[#slist+1]=str
		mark = 1 + (chk[1] or string.len(s))
	end
	return slist
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
	if string.len(locs) == 0 then 
		Debug.Message("fusf.Loc() wrong value")
		return 0 
	end
	local loctable = {0,0}
	local locmark = 1
	for i = 1,string.len(locs) do
		local loc = string.sub(locs,i,i)
		if loc == "+" then
			locmark = locmark + 1
		else
			loctable[locmark] = loctable[locmark] + fucg.ran[string.upper(loc)]
		end
	end
	if chk then loctable = {loctable[1]} end
	return table.unpack(loctable)
end
function fusf.Not_All_nil(...)
	local v = {...}
	v=type(v) =="table" and type(v[1]) =="table" and v[1] or v
	for _,l in pairs(v) do
		return l
	end
	return false
end
function fusf.GetCardTable(c)
--return Card Table
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
function fusf.des(e,v)
--return des
	v = #v==1 and v[1] or v
	if type(v) == "table" then
		v = aux.Stringid(table.unpack(v))
	elseif type(v) == "string" then
		v = fucg.des[v]
	elseif type(v) == "number" then
		v = v<17 and aux.Stringid(e:GetOwner():GetOriginalCode(),v) or v
	end
	return e,v
end
function fusf.cat(v)
--return category
	return type(v) == "string" and fucg.cat[v] or v
end
function fusf.cod(v)
--return code
	return type(v) == "string" and fucg.cod[v] or v
end
function fusf.pro(s,v)
--return property
	if s and type(s) ~= "string" then return s end
	local pro = 0
	for _,S in ipairs(fusf.CutString(s,"+")) do
		pro = pro + fucg.pro[string.upper(S)]
	end
	if v then pro=pro+v end
	return pro
end
function fusf.ctl(e,v)
--return count limit
	v = type(v) == "table" and v or { v }
	local V = {nil,nil,nil}
	for i = #v,1 do
		V[3] = type(v[i]) == "string" and v[i] or V[3]
		V[2] = type(v[i]) == "number" and v[i]>99 and v[i] or V[2]
		V[1] = type(v[i]) == "number" and v[i]<99 and v[i] or V[1]
	end
	if V[3] and not V[2] then V[2] = e:GetOwner():GetOriginalCode() end
	if V[3] then V[2] = V[2] + fucg.ctl[V[3] ] end
	V[1] = V[1] or 1
	return e,table.unpack(V)
end
function fusf.res(v)
--return Reset
	v = type(v) == "table" and v or { v }
	return table.unpack(v)
end