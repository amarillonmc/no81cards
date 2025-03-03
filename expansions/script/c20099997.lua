dofile("expansions/script/c20099998.lua")
if fucf then return end
fucf, fugf = { }, { }
-------------------------------------- Group function
function fugf.Get(_tp, _loc)
	return Duel.GetFieldGroup(_tp, fusf.Get_Loc(_loc))
end
function fugf.Filter(_g, _func, _val, _n, ...)
	return fusf.Creat_GF(_func, _val, ...)(_g, _n)
end
function fugf.GetFilter(_tp, _loc, _func, _val, _n, ...)
	return fugf.Filter(fugf.Get(_tp, _loc), _func, _val, _n, ...)
end
function fugf.Select(_tp, _g, _func, _val, _min, _max, ...)
	local g = _g
	if type(_g) == "string" then g = fugf.Get(_tp, _g) end -- _g is loc
	if _func then 
		if type(_func) == "number" then -- _func is _min
			_min, _max = _func, _val or _func
		else -- _func is _func
			g = fugf.Filter(g, _func, _val, nil, ...)
		end
	end
	return g:Select(_tp, _min or 1, _max or _min or 1, nil)
end
function fugf.SelectTg(_tp, _g, _func, _val, _min, _max, ...)
	local g = fugf.Select(_tp, _g, _func, _val, _min, _max, ...)
	Duel.SetTargetCard(g)
	return g
end
--------------------------------------"Card function" (use in initial (no return 
function fucf.AddCode(c, ...)
	local codes = { }
	for _, _code in ipairs({...}) do
		if type(_code) == "string" then 
			for _, cod in ipairs(fusf.CutString(_code, ",", "AddCode")) do
				codes[#codes + 1] = fusf.M_chk(cod)
			end
		else
			codes[#codes + 1] = fusf.M_chk(_code)
		end
	end
	aux.AddCodeList(c, table.unpack(codes))
end
fucf.ReviveLimit = Card.EnableReviveLimit
--------------------------------------"Card function" (use in Filter
function fucf.Filter(c, _func, ...)
	return fusf.Creat_CF(_func, {...})(c)
	--return fugf.Filter(Group.FromCards(c), func, {...}, 1)
end
fucf.IsRk   = fusf.IsN("GetRank")
fucf.IsLv   = fusf.IsN("GetLevel")
fucf.IsRLv  = fusf.IsN("GetRitualLevel")
fucf.IsLk   = fusf.IsN("GetLink")
fucf.IsAtk  = fusf.IsN("GetAttack")
fucf.IsDef  = fusf.IsN("GetDefense")
fucf.IsSeq  = fusf.IsN("GetSequence")
fucf.IsPSeq = fusf.IsN("GetPreviousSequence")
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
	for _,Set in ipairs(fusf.CutString(set, "/")) do
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
function fucf.CanSp(c, e, typ, tp, nochk, nolimit, pos, totp, zone)
	if not tp then tp = e:GetHandlerPlayer() end
	return c:IsCanBeSpecialSummoned(e, typ, tp, nochk or false, nolimit or false, pos or POS_FACEUP, totp or tp,zone or 0xff)
end
function fucf.IsCode(c, _cod)
	local cod
	if aux.GetValueType(_cod) == "number" then
		cod = {_cod}
	elseif aux.GetValueType(_cod) == "string" then
		cod = fusf.CutString(_cod, "+")
	elseif aux.GetValueType(_cod) == "table" then
		cod = _cod
	end
	for i,v in ipairs(cod) do
		cod[i] = fusf.M_chk(tonumber(v))
	end
	return c:IsCode(table.unpack(cod))
end
function fucf.HasCode(c, _cod)
	if not c.card_code_list then return false end
	local cod, has
	if aux.GetValueType(_cod) == "number" then
		cod = {_cod}
	elseif aux.GetValueType(_cod) == "string" then
		cod = fusf.CutString(_cod, "+")
	end
	for i,v in ipairs(cod) do
		has = has or c.card_code_list[fusf.M_chk(tonumber(v))]
	end
	return has
end
fucf.TgChk  = Card.IsCanBeEffectTarget
fucf.GChk   = function(c) return not c:IsHasEffect(EFFECT_NECRO_VALLEY) end
fucf.IsImm  = Card.IsImmuneToEffect
fucf.IsCon  = Card.IsControler
fucf.IsPCon = Card.IsPreviousControler
fucf.IsLoc  = function(c,loc) return c:IsLocation(fusf.Get_Loc(loc)) end
fucf.IsPLoc = function(c,loc) return c:IsPreviousLocation(fusf.Get_Loc(loc)) end
fucf.IsRea  = fusf.Is_Cons("GetReason", "rea")
fucf.IsTyp  = fusf.Is_Cons("GetType", "typ")
fucf.IsSTyp = fusf.Is_Cons("GetSummonType", "styp")
fucf.IsOTyp = fusf.Is_Cons("GetOriginalType", "typ")
fucf.IsAtt  = fusf.Is_Cons("GetAttribute", "att")
fucf.IsRac  = fusf.Is_Cons("GetRace", "rac")
fucf.IsPos  = fusf.Is_Cons("GetPosition", "pos", function(card_val, val) return card_val | val == val end)
fucf.IsPPos = fusf.Is_Cons("GetPreviousPosition", "pos", function(card_val, val) return card_val | val == val end)

---------------------------------------------------------------- procedure
function fucf.RMFilter(c, rf, e, tp, g1, g2, level_function, greater_or_equal, chk)
	if rf and not rf(c, e, tp, chk) then return false end
	if not fucf.Filter(rc, "IsTyp+CanSp", "RI+M", {e, SUMMON_TYPE_RITUAL, tp, false, true}) then return false end
	local g = g1:Filter(Card.IsCanBeRitualMaterial, c, c) + (g2 or Group.CreateGroup())
	g = g:Filter(c.mat_filter or aux.TRUE, c, tp)
	local lv = level_function(c)
	Auxiliary.GCheckAdditional = Auxiliary.RitualCheckAdditional(c, lv, greater_or_equal)
	local res = g:CheckSubGroup(Auxiliary.RitualCheck, 1, lv, tp, c, lv, greater_or_equal)
	Auxiliary.GCheckAdditional = nil
	return res
end