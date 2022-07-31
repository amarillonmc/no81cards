fucg = fucg or {}
local fu = fucg
if fu.var then return end
fu.var = true
fu.ef = { }  --"Effect Function"
fu.sf = { }  --"Support Function"
fu.df = { }  --"Duel Function"
--Hint Variable
fu.des = {
	["TH"] = 1190   ,  --加入手卡
	["TG"] = 1191   ,  --送去墓地
	["RE"] = 1192   ,  --除外
	["SP"] = 1152   ,  --特殊召唤
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
	["O"] = EFFECT_COUNT_CODE_OATH  ,  --发动次数
	["D"] = EFFECT_COUNT_CODE_DUEL  ,  --决斗次数
	["S"] = EFFECT_COUNT_CODE_SINGLE  ,  --公共次数
}
--Effect Variable
fu.eff = {
	CRE   = Effect.CreateEffect,
	DES   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetDescription(e,fu.sf.des({...})) end end,
	CAT   = function(e,v) if v then Effect.SetCategory(e,v) end end,
	TYP   = function(e,v) if v then Effect.SetType(e,v) end end,
	COD   = function(e,v) if v then Effect.SetCode(e,fu.sf.cod(v)) end end,
	CTL   = function(e,...) if fu.sf.Not_All_nil(...) then Effect.SetCountLimit(e,fu.sf.ctl({...})) end end,
	PRO   = function(e,v) if v then Effect.SetProperty(e,v) end end,
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
fu.df = {
	GMG  = function(f,tp,loc1,loc2,c,...) return Duel.GetMatchingGroup(f,tp,fu.sf.ran(loc1),fu.sf.ran(loc2),c,...) end,
	IEMC = function(f,tp,loc1,loc2,n,c,...) return Duel.IsExistingMatchingCard(f,tp,fu.sf.ran(loc1),fu.sf.ran(loc2),n,c,...) end,
	IET  = function(f,tp,loc1,loc2,n,c,...) return Duel.IsExistingTarget(f,tp,fu.sf.ran(loc1),fu.sf.ran(loc2),n,c,...) end,
}
--------------------------------------"Support Function"
function fu.sf.Not_All_nil(...)
	local v = {...}
	for _,l in ipairs(v) do
		if l then return true end
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
function fu.sf.des(v)
--return des
	v = type(v[1]) == "table" and v[1] or v
	if type(v) == "table" then
--{m,0}
		v = aux.Stringid(table.unpack(v))
	elseif type(v) == "string" then
		v = fu.des[v]
	elseif type(v) == "number" then
--m + 0xn0000000
		v = aux.Stringid(v&0xff,v>>28)
	end
	return v
end
function fu.sf.cod(v)
--return code
	return type(v) == "string" and fu.cod[v] or v
end
function fu.sf.ran(v)
--return range
	v = { 0, table.unpack(type(v) == "table" and v or { v }) }
	for _,l in ipairs(v) do
		v[1] = v[1] + (type(l) == "string" and fu.ran[l] or l)
	end
	return v[1]
end
function fu.sf.ctl(v)
--return count limit
	v = type(v) == "table" and v or { v }
	v = {v[1]>99 and 1 or v[1], v[1]>99 and v[1] + (fu.ctl[v[2] ] or 0) or (v[2] or 0) + (fu.ctl[v[3] ] or 0)}
	return table.unpack(v)
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



