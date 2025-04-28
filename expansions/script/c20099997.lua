dofile("expansions/script/c20099998.lua")
if fucf then return end
fucf, fugf = { }, { }
-------------------------------------- Group function
function fugf.Get(p, loc)
	return Duel.GetFieldGroup(p, fusf.Get_Loc(loc))
end
function fugf.Filter(g, f, v, n, ...)
	return fusf.Creat_GF(f, v, ...)(g, n)
end
function fugf.GetFilter(p, loc, f, v, n, ...)
	return fugf.Filter(fugf.Get(p, loc), f, v, n, ...)
end
function fugf.GetNoP(loc, f, v, n, ...)
	local val = {...}
	return function(p)
		return fugf.GetFilter(p, loc, f, v, n, table.unpack(val))
	end
end
function fugf.Select(p, g, f, v, min, max, ...)
	if type(g) == "string" then g = fugf.Get(p, g) end -- _g is loc
	if type(f) == "number" then -- f is min
		min, max = f, v
	elseif f then -- f is func
		g = fugf.Filter(g, f, v, nil, ...)
	end
	min = min or 1
	max = max or min
	if #g == min then return g end
	return g:Select(p, min, max, nil)
end
function fugf.SelectTg(p, g, f, v, min, max, ...)
	local g = fugf.Select(p, g, f, v, min, max, ...)
	Duel.SetTargetCard(g)
	return g
end
--------------------------------------"Card function" (use in initial (no return 
function fucf.AddCode(c, ...)
	local codes = { }
	for _, _code in ipairs({...}) do
		if type(_code) == "string" then 
			for _, cod in _code:ForCut("fucf.AddCode") do
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
function fucf.IsSet(c, sets)
	if type(sets) == "number" then return c:IsSetCard(sets) end
	for _, set in sets:ForCut("fucf.IsSet", "/") do
		set = tonumber(set, 16)
		if set and c:IsSetCard(set) then return true end
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
	if typ == SUMMON_TYPE_RITUAL or typ == "RI" then
		typ = SUMMON_TYPE_RITUAL
		nochk = nochk or false
		nolimit = nolimit or true
	end
	return c:IsCanBeSpecialSummoned(e, typ, tp, nochk or false, nolimit or false, pos or POS_FACEUP, totp or tp,zone or 0xff)
end
function fucf.IsCode(c, _cod)
	local cod
	if aux.GetValueType(_cod) == "number" then
		cod = {_cod}
	elseif aux.GetValueType(_cod) == "string" then
		cod = _cod:Cut("fucf.IsCode", "+")
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
		cod = _cod:Cut("fucf.HasCode", "+")
	end
	for i,v in ipairs(cod) do
		has = has or c.card_code_list[fusf.M_chk(tonumber(v))]
	end
	return has
end
function fucf.CanEq(c, tp)
	return c:CheckUniqueOnField(tp) and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
end
function fucf.IsFlagLab(c, _cod, _lab)
	return c:GetFlagEffectLabel(_cod) == _lab
end
function fucf.IsCon(c, p)
	if type(p) == "string" then p = tonumber(p) end
	return c:IsControler(p)
end
fucf.InGroup = function(c, g) return g:IsContains(c) end
fucf.TgChk  = Card.IsCanBeEffectTarget
fucf.GChk   = function(c) return not c:IsHasEffect(EFFECT_NECRO_VALLEY) end
fucf.IsImm  = Card.IsImmuneToEffect
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