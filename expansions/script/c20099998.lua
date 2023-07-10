if not pcall(function() require("expansions/script/c20099999") end) then require("script/c20099999") end
if fucf then return end
fucf, fugf = { }, { }
--------------------------------------"Card function"
function fucf.Filter(c,f,...)
	local v = {...}
	v = #v==1 and v[1] or v
	return fugf.Filter(Group.FromCards(c),f,v,1)
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
function fucf.Not(c,val)
	if aux.GetValueType(val) == "Card" then
		return c ~= val
	elseif aux.GetValueType(val) == "Effect" then
		return c ~= e:GetHandler()
	elseif aux.GetValueType(val) == "Group" then
		return not val:IsContains(c)
	elseif aux.GetValueType(val) == "function" then
		return not val(c)
	end
	return false
end
fucf.TgChk = Card.IsCanBeEffectTarget
fucf.GChk = function(c)return not c:IsHasEffect(EFFECT_NECRO_VALLEY) end
fucf.IsImm = Card.IsImmuneToEffect
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
	func = "IsAbleTo"..func[loc]
	if iscos then func = func.."AsCost" end
	return Card[func](c)
end
function fucf.CanSp(c,e,typ,tp,nochk,nolimit,pos,totp,zone)
	return c:IsCanBeSpecialSummoned(e, typ, tp, nochk or false, nolimit or false, pos or POS_FACEUP, totp or tp,zone or 0xff)
end
function fucf.IsCod(c,cod)
	if type(cod) == "string" then cod = tonumber(cod) end
	return c:IsCode(cod)
end
function fucf.IsLoc(c,loc)
	return c:IsLocation(fusf.Loc(loc))
end
function fucf.CheckConstantValue(func,chktable)
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
fucf.IsRea = fucf.CheckConstantValue(function(c,v) return c:IsReason(v) end,fucg.rea)
fucf.IsTyp = fucf.CheckConstantValue(function(c,v) return c:GetType()&v==v end,fucg.typ)
fucf.IsAtt = fucf.CheckConstantValue(function(c,v) return c:GetAttribute()&v==v end,fucg.att)
fucf.IsRac = fucf.CheckConstantValue(function(c,v) return c:GetRace()&v==v end,fucg.rac)
fucf.IsPos = fucf.CheckConstantValue(function(c,v) return c:IsPosition(v) end,fucg.pos)
--------------------------------------"Group function"
function fugf.Get(p,loc)
	return Duel.GetFieldGroup(p,fusf.Loc(loc))
end
function fugf.Filter(g,f,v,n)
	local func, tStack, index = { }, { }, 1
	v = type(v) == "table" and v or { v }
	func = type(f) == "string" and fusf.PostFix_Trans(f,v) or { f }
	local var = fusf.Value_Trans(v)
--------------------------------------------
	if #func==1 then
		if type(func[1]) == "string" then func[1] = fucf[func[1] ] or Card[func[1] ] or aux[func[1] ] end
		g = g:Filter(func[1] or aux.TRUE,nil,table.unpack(var))
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
				if type(val) == "string" then val = fucf[val] or Card[val] or aux[val] end
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
function fugf.GetFilter(p,loc,f,v,n)
	return fugf.Filter(fugf.Get(p,loc),f,v,n)
end
function fugf.SelectFilter(p,loc,f,v,c,min,max,sp)
	min=min or 1
	return fugf.GetFilter(p,loc,f,v):Select(sp or p,min,max or min,c)
end
function fugf.SelectTg(p,loc,f,v,c,min,max,sp)
	local g=fugf.SelectFilter(p,loc,f,v,c,min,max,sp)
	Duel.SetTargetCard(g)
	return g
end