fucg = fucg or {}
local fu = fucg
if fu.var then return end
fu.var = true
fu.ef = { }  --"Effect Function"
fu.sf = { }  --"Support Function"
fu.df = { }  --"Duel Function"
fu.gf = { }  --"Group Function"
--Hint Variable
fu.des = {
	["TH"] = 1190   ,  --加入手卡
	["TG"] = 1191   ,  --送去墓地
	["RE"] = 1192   ,  --除外
	["SP"] = 1152   ,  --特殊召唤
}
--category Variable
fu.cat = {
	["SH"] = 0x20008	, --CATEGORY_SEARCH+CATEGORY_TOHAND
	["SP"] = CATEGORY_SPECIAL_SUMMON	,
}
--code Variable
fu.cod = {
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
fu.pro = {
	["TG"] = EFFECT_FLAG_CARD_TARGET   ,
	["DE"] = EFFECT_FLAG_DELAY  ,
	["SR"] = EFFECT_FLAG_SINGLE_RANGE   ,
	["HINT"] = EFFECT_FLAG_CLIENT_HINT   ,
	["OE"] = 17408   , --EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE(out effect)
}
--Location Variable
fu.ran = {
	["H"] = LOCATION_HAND   ,
	["D"] = LOCATION_DECK   ,
	["G"] = LOCATION_GRAVE  ,
	["R"] = LOCATION_REMOVED	,
	["E"] = LOCATION_EXTRA  ,
	["M"] = LOCATION_MZONE  ,
	["S"] = LOCATION_SZONE  ,
	["F"] = LOCATION_FZONE  ,
	["OF"] = LOCATION_OVERLAY   ,
	["O"] = LOCATION_OVERLAY	,
	["P"] = LOCATION_PZONE 
}
--Phase Variable
fu.pha = {
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
fu.ctl = {
	O = EFFECT_COUNT_CODE_OATH  ,  --发动次数
	D = EFFECT_COUNT_CODE_DUEL  ,  --决斗次数
	S = EFFECT_COUNT_CODE_SINGLE  ,  --公共次数
}
--Effect Variable
fu.eff = {
	CRE   = Effect.CreateEffect,
	DES   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetDescription(fu.sf.des(e,{...})) end end,
	CAT   = function(e,v) if v then Effect.SetCategory(e,fu.sf.cat(v)) end end,
	TYP   = function(e,v) if v then Effect.SetType(e,v) end end,
	COD   = function(e,v) if v then Effect.SetCode(e,fu.sf.cod(v)) end end,
	CTL   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetCountLimit(fu.sf.ctl(e,{...})) end end,
	PRO   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetProperty(e,fu.sf.pro({...})) end end,
	RAN   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetRange(e,fu.sf.ran({...})) end end,
	CON   = function(e,v) if v then Effect.SetCondition(e,v) end end,
	COS   = function(e,v) if v then Effect.SetCost(e,v) end end,
	TG  = function(e,v) if v then Effect.SetTarget(e,v) end end,
	OP  = function(e,v) if v then Effect.SetOperation(e,v) end end,
	VAL   = function(e,v) if v then Effect.SetValue(e,v) end end,
	RES   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetReset(e,fu.sf.res({...})) end end,
	TRAN  = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetTargetRange(e,fu.sf.tran({...})) end end,
	LAB   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetLabel(e,...) end end,
	LABOBJ= function(e,v) if v then Effect.SetLabelObject(e,v) end end,
	CLO   = Effect.Clone,
}
--------------------------------------"Duel Function"
function fu.df.GG(tp,loc1,loc2)
	return Duel.GetFieldGroup(tp,fu.sf.ran(loc1),fu.sf.ran(loc2))
end
--------------------------------------"Group Function"
function fu.gf.GF(g,f,v,c,n) --(group, filter, filter value, not c, is more than n)
	if c then g = g:Filter(aux.TRUE,c) end
	f = type(f) =="table" and f or { f }
	v = type(v) =="table" and v or { v }
	for i,F in pairs(f) do
		if F then 
			local V = v[i] and (type(v[i]) =="table" and v[i] or {v[i]}) or {}
			g = g:Filter(F,nil,table.unpack(V))
		end
	end
	if n then return #g >= n end
	return g
end
function fu.gf.GGF(tp,loc1,loc2,f,v,c,n)
	return fu.gf.GF(fu.df.GG(tp,loc1,loc2),f,v,c,n)
end
--------------------------------------"Support Function"
function fu.sf.Not_All_nil(...)
	local v = {...}
	v=type(v) =="table" and type(v[1]) =="table" and v[1] or v
	for _,l in pairs(v) do
		return l
	end
	return false
end
function fu.sf.GetCardTable(c)
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
function fu.sf.des(e,v)
--return des
	v = type(v) == "table" and #v==1 and v[1] or v
	if type(v) == "table" then
		v = aux.Stringid(table.unpack(v))
	elseif type(v) == "string" then
		v = fu.des[v]
	elseif type(v) == "number" then
		v = v<17 and aux.Stringid(e:GetOwner():GetOriginalCode(),v) or v
	end
	return e,v
end
function fu.sf.cat(v)
--return category
	return type(v) == "string" and fu.cat[v] or v
end
function fu.sf.cod(v)
--return code
	return type(v) == "string" and fu.cod[v] or v
end
function fu.sf.pro(v)
--return property
	v = { 0, table.unpack(type(v) == "table" and v or { v }) }
	for _,l in ipairs(v) do
		v[1] = v[1] + (type(l) == "string" and fu.pro[l] or l)
	end
	return v[1]
end
function fu.sf.ran(v)
--return range
	v = { 0, table.unpack(type(v) == "table" and v or { v }) }
	for _,l in ipairs(v) do
		v[1] = v[1] + (type(l) == "string" and fu.ran[l] or l)
	end
	return v[1]
end
function fu.sf.ctl(e,v)
--return count limit
	v = type(v) == "table" and v or { v }
	local V = {nil,nil,nil}
	for i = #v,1 do
		V[3] = type(v[i]) == "string" and v[i] or V[3]
		V[2] = type(v[i]) == "number" and v[i]>99 and v[i] or V[2]
		V[1] = type(v[i]) == "number" and v[i]<99 and v[i] or V[1]
	end
	if V[3] and not V[2] then V[2] = e:GetOwner():GetOriginalCode() end
	if V[3] then V[2] = V[2] + fu.ctl[V[3] ] end
	V[1] = V[1] or 1
	return e,table.unpack(V)
end
function fu.sf.res(v)
--return Reset
	v = type(v) == "table" and v or { v }
	return table.unpack(v)
end
function fu.sf.tran(v)
--return target range
	v = type(v) == "table" and (#v == 2 and v or { v[1], v[1] } ) or { v, v }
	return table.unpack(v)
end

