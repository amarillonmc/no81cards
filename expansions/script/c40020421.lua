--瞬耀-梅萨F02型 布雷装备［加尔松宗搭乘］
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	aux.AddXyzProcedure(c, nil, 3, 2)
	c:EnableReviveLimit()

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_COUNTER + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.e2con)
	e2:SetCost(s.e2cost)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)

	if chk == 0 then return true end
	
	Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 1, 0, 0x1f1e)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_OVERLAY)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local xi_on_field = Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(40020396) end, tp, LOCATION_MZONE, 0, 1, nil)
	
	if xi_on_field then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_COUNTER)
		local tc = Duel.SelectMatchingCard(tp, function(c) return c:IsFaceup() and c:IsCode(40020396) end, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
		if tc then
			tc:AddCounter(0x1f1e, 1)
			Duel.RegisterFlagEffect(tp, 40020396, 0, 0, 1)
		end
	else
		if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
		
		local g = Group.CreateGroup()
		
		local g_hand = Duel.GetMatchingGroup(function(c) return c:IsCode(40020396) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end, tp, LOCATION_HAND, 0, nil)
		g:Merge(g_hand)
		
		local xyz_filter = function(c)
			return c:IsFaceup() and c:IsType(TYPE_XYZ) and s.XiGundam(c)
		end
		local g_xyz = Duel.GetMatchingGroup(xyz_filter, tp, LOCATION_MZONE, 0, nil)
		
		for xc in aux.Next(g_xyz) do
			local overlay = xc:GetOverlayGroup()
			local valid_overlay = overlay:Filter(function(c) return c:IsCode(40020396) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end, nil)
			g:Merge(valid_overlay)
		end
		
		if g:GetCount() > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sg = g:Select(tp, 1, 1, nil)
			Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end
function s.e2cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end
function s.e2con(e, tp, eg, ep, ev, re, r, rp)
	local tc = eg:GetFirst()
	return tc:IsControler(tp) 
	   and (tc:IsLevelAbove(5) or tc:IsRankAbove(5)) 
	   and tc:IsStatus(STATUS_OPPO_BATTLE) 
	   and tc:IsRelateToBattle()
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local tc = eg:GetFirst()
	if tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_BATTLE)
		tc:RegisterEffect(e1)
	end
end
