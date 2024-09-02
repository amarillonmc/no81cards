xpcall(function() dofile("expansions/script/c20099998.lua") end,function() dofile("script/c20099998.lua") end)
if fucf then return end
fucf, fugf = { }, { }
--------------------------------------"Group function"
function fugf.Filter(g, f, v, n)
	v = type(v) == "table" and v or { v }
	local func = type(f) == "string" and fusf.PostFix_Trans(f,v) or { f }
	local _g, var = { }, fusf.Value_Trans(table.unpack(v))
--------------------------------------------
	if #func==1 then
		if type(func[1]) == "string" then func[1] = fucf[func[1] ] or Card[func[1] ] or aux[func[1] ] end
		g = g:Filter(func[1] or aux.TRUE,nil,table.unpack(var))
	elseif fusf.NotNil(func) then
		local CalL, CalR
		for _,val in ipairs(func) do
			if val == "~" then
				_g[#_g] = g - _g[#_g]
			elseif type(val) == "string" and #val == 1 then
				CalR = table.remove(_g)
				CalL = table.remove(_g)
				local tCalc = {
					["+"] = CalL & CalR,
					["-"] = CalL - CalR,
					["/"] = CalL + CalR
				}
				table.insert(_g, tCalc[val])
			else
				if type(val) == "string" then val = fucf[val] or Card[val] or aux[val] end
				local V = table.remove(var,1)
				V = V and (type(V) =="table" and V or {V}) or { }
				table.insert(_g, g:Filter(val,nil,table.unpack(V)))
			end
		end
		g = table.remove(_g)
	end
	if n then return n>0 and #g>=n or (n<0 and #g<-n) end
	return g
end
function fugf.Get(tp,loc) 
	return Duel.GetFieldGroup(tp,fusf.Get_Loc(loc)) 
end
function fugf.GetFilter(tp,loc,f,v,n) 
	return fugf.Filter(fugf.Get(tp,loc),f,v,n) 
end
function fugf.SelectFilter(tp,loc,f,v,c,min,max,sp) 
	return fugf.GetFilter(tp,loc,f,v):Select(sp or tp,min or 1,max or min or 1,c) 
end
function fugf.SelectTg(tp,loc,f,v,c,min,max,sp)
	local g=fugf.SelectFilter(tp,loc,f,v,c,min,max,sp)
	Duel.SetTargetCard(g)
	return g
end
--------------------------------------"Card function"
function fucf.Filter(c,f,...)
	local v = {...}
	v = #v==1 and v[1] or v
	return fugf.Filter(Group.FromCards(c),f,v,1)
end
function fucf.IsN(func)
	return function(c, val, exval)
		if type(val) == "string" and val:match("[%+%-]") then
			local st, ed  = val:find("[%+%-]")
			if st == 1 then
				st, ed = 2, #val
			else
				st, ed = 1, #val -1
			end
			local _val = math.abs(tonumber(val:sub(st, ed)))
			local Cal = {
				["+"] = Card[func](c, exval) >= _val,
				["-"] = Card[func](c, exval) <= _val
			}
			return Cal[val:match("[%+%-]")]
		end
		return Card[func](c,exval) == tonumber(val)
	end
end
fucf.IsRk = fucf.IsN("GetRank")
fucf.IsLv = fucf.IsN("GetLevel")
fucf.IsRLv = fucf.IsN("GetRitualLevel")
fucf.IsLk = fucf.IsN("GetLink")
fucf.IsAtk = fucf.IsN("GetAttack")
fucf.IsDef = fucf.IsN("GetDefense")
function fucf.Not(c,val)
	if aux.GetValueType(val) == "Card" then
		return c ~= val
	elseif aux.GetValueType(val) == "Effect" then
		return c ~= val:GetHandler()
	elseif aux.GetValueType(val) == "Group" then
		return not val:IsContains(c)
	elseif aux.GetValueType(val) == "function" then
		return not val(c)
	end
	return false
end
function fucf.IsSet(c,set)
	if type(set) == "number" then return c:IsSetCard(set) end
	for _,Set in ipairs(fusf.CutString(set,"/")) do
		Set=tonumber(Set,16)
		if Set and c:IsSetCard(Set) then return true end
	end
	return false
end
function fucf.AbleTo(c,loc)
	local func = {
		["H"] = "Hand"   ,
		["D"] = "Deck"   ,
		["G"] = "Grave"  ,
		["R"] = "Remove",
		["E"] = "Extra"  ,
	}
	local iscos = string.sub(loc,1,1) == "*"
	if iscos then loc = string.sub(loc,2) end
	return Card["IsAbleTo"..func[loc]..(iscos and "AsCost" or "")](c)
end
function fucf.CanSp(c,e,tp,typ,nochk,nolimit,pos,totp,zone)
	return c:IsCanBeSpecialSummoned(e, typ, tp, nochk or false, nolimit or false, pos or POS_FACEUP, totp or tp,zone or 0xff)
end
function fucf.IsCod(c,cod)
	local _cod
	if aux.GetValueType(cod) == "number" then
		_cod = {cod}
	elseif aux.GetValueType(cod) == "string" then
		_cod = fusf.CutString(cod, ",")
	elseif aux.GetValueType(cod) == "table" then
		_cod = cod
	end
	for i,v in ipairs(_cod) do
		_cod[i] = tonumber(v)<19999999 and (tonumber(v)+20000000) or tonumber(v)
	end
	return c:IsCode(table.unpack(_cod))
end
function fucf.AddCode(c, ...)
	local _codes = {...}
	for i,code in ipairs(_codes) do
		if (code < 19999999) then _codes[i] = code + 20000000 end
	end
	aux.AddCodeList(c,table.unpack(_codes))
end
function fucf.HasCode(c, cod)
	local _cod = tonumber(cod)
	_cod = (_cod < 19999999) and _cod + 20000000 or _cod
	return aux.IsCodeListed(c,_cod)
end
fucf.TgChk = Card.IsCanBeEffectTarget
fucf.GChk = function(c) return not c:IsHasEffect(EFFECT_NECRO_VALLEY) end
fucf.IsImm = Card.IsImmuneToEffect
fucf.IsCon = Card.IsControler
fucf.IsPCon = Card.IsPreviousControler
fucf.IsLoc = function(c,loc) return c:IsLocation(fusf.Get_Loc(loc)) end
fucf.IsPLoc = function(c,loc) return c:IsPreviousLocation(fusf.Get_Loc(loc)) end
fucf.IsRea  = fusf.Check_Constant(function(c,v) return c:GetReason()&v==v end,fucs.rea)
fucf.IsTyp  = fusf.Check_Constant(function(c,v) return c:GetType()&v==v end,fucs.typ)
fucf.IsSTyp  = fusf.Check_Constant(function(c,v) return c:IsSummonType(v) end,fucs.styp)
fucf.IsOTyp = fusf.Check_Constant(function(c,v) return c:GetOriginalType()&v==v end,fucs.typ)
fucf.IsAtt = fusf.Check_Constant(function(c,v) return c:GetAttribute()&v==v end,fucs.att)
fucf.IsRac = fusf.Check_Constant(function(c,v) return c:GetRace()&v==v end,fucs.rac)
fucf.IsPos = fusf.Check_Constant(function(c,v) return c:IsPosition(v) end,fucs.pos)
fucf.IsPPos = fusf.Check_Constant(function(c,v) return c:IsPreviousPosition(v) end,fucs.pos)