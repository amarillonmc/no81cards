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
	["DE"] = EFFECT_FLAG_DELAY  ,
	["SR"] = EFFECT_FLAG_SINGLE_RANGE   ,
	["HINT"] = EFFECT_FLAG_CLIENT_HINT   ,
	["OE"] = 17408   , --EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE(out effect)
}
--Location Variable
fucg.ran = {
	["H"] = LOCATION_HAND   ,
	["D"] = LOCATION_DECK   ,
	["G"] = LOCATION_GRAVE  ,
	["R"] = LOCATION_REMOVED,
	["E"] = LOCATION_EXTRA  ,
	["M"] = LOCATION_MZONE  ,
	["S"] = LOCATION_SZONE  ,
	["F"] = LOCATION_FZONE  ,
	["O"] = LOCATION_OVERLAY,
	["P"] = LOCATION_PZONE 
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
--Effect Variable
fucg.eff = {
	CRE   = Effect.CreateEffect,
	DES   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetDescription(fusf.des(e,{...})) end end,
	CAT   = function(e,v) if v then Effect.SetCategory(e,fusf.cat(v)) end end,
	TYP   = Effect.SetType,
	COD   = function(e,v) if v then Effect.SetCode(e,fusf.cod(v)) end end,
	CTL   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetCountLimit(fusf.ctl(e,{...})) end end,
	PRO   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetProperty(e,fusf.pro({...})) end end,
	RAN   = function(e,v) if v then Effect.SetRange(e,fusf.Loc(v,1)) end end,
	CON   = Effect.SetCondition,
	COS   = Effect.SetCost,
	TG  = Effect.SetTarget,
	OP  = Effect.SetOperation,
	VAL   = Effect.SetValue,
	RES   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetReset(e,fusf.res({...})) end end,
	TRAN  = function(e,...) if fusf.Not_All_nil(...) then Effect.SetTargetRange(e,fusf.tran({...})) end end,
	LAB   = function(e,...) if fusf.Not_All_nil(...) then Effect.SetLabel(e,...) end end,
	LABOBJ= Effect.SetLabelObject,
	CLO   = Effect.Clone,
}
--------------------------------------"Card function"
function fucf.IsLoc(c,loc)
	return c:IsLocation(fusf.Loc(loc))
end
function fucf.TgChk(c,e)
	return c:IsCanBeEffectTarget(e)
end
--------------------------------------"Group function"
function fugf.Get(p,loc)
	return Duel.GetFieldGroup(p,fusf.Loc(loc))
end
function fugf.Filter(g,f,v,c,n)
	if c then g = g:Filter(aux.TRUE,c) end
	f = type(f) =="table" and f or { f }
	v = type(v) =="table" and v or { v }
	if #f==1 then 
		g = g:Filter(f[1],nil,table.unpack(v))
	else
		for i,F in pairs(f) do
			if F then 
				local V = v[i] and (type(v[i]) =="table" and v[i] or {v[i]}) or {}
				g = g:Filter(F,nil,table.unpack(V))
			end
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
		local loc = string.sub(locs, i, i)
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
function fusf.pro(v)
--return property
	v = { 0, table.unpack(type(v[1]) == "table" and v[1] or v) }
	for _,l in ipairs(v) do
		v[1] = v[1] + (type(l) == "string" and fucg.pro[l] or l)
	end
	return v[1]
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
function fusf.tran(v)
--return target range
	v = type(v[1]) == "table" and v[1] or v
	return table.unpack(v)
end

