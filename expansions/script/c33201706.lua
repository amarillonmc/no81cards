--圣兽集结-比斯特基地
local cm, m, o = GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	aux.AddXyzProcedure(c,cm.mfilter,4,2)

	--① effect
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m, 2))
	-- e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1, m)
	e1:SetCondition(cm.xyzcon)
	e1:SetTarget(cm.xyztg)
	e1:SetOperation(cm.xyzop)
	c:RegisterEffect(e1)

	-- Also trigger during opponent's main phase
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m, 0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, m + 10000)
	e3:SetCondition(cm.oppcon)
	e3:SetTarget(cm.eqtg)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)
end

--① effect functions
function cm.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.xyzcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function cm.filter(c)
	return c:IsCode(33201707) and c:IsSSetable()
end

function cm.xyztg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_SEARCH, nil, 1, tp, LOCATION_DECK)
end

function cm.xyzop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstMatchingCard(function(c)
		return c:IsCode(33201707) and c:IsSSetable()
	end, tp, LOCATION_DECK, 0, nil)
	if tc then
		Duel.SSet(tp, tc)
	end
end

--② effect functions
function cm.oppcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetCurrentPhase() == PHASE_MAIN2 or Duel.GetCurrentPhase() == PHASE_MAIN1
end

function cm.eqtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return c:GetOverlayGroup():IsExists(Card.IsType, 1, nil, TYPE_UNION)
			and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	end
	Duel.SetOperationInfo(0, CATEGORY_EQUIP, nil, 1, tp, LOCATION_OVERLAY)
end

function cm.eqop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g = c:GetOverlayGroup():Filter(Card.IsType, nil, TYPE_UNION)
	if #g == 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
	local tc = g:Select(tp, 1, 1, nil):GetFirst()
	if tc then
		-- Duel.Overlay(c, Group.RemoveCard(g, tc))
		Duel.Equip(tp, tc, c)
		-- Equip limit
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		tc:RegisterEffect(e1)
		-- Make it treated as Equip Card
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(TYPE_SPELL + TYPE_EQUIP)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
		tc:RegisterEffect(e2)
	end
end

function cm.eqlimit(e, c)
	return e:GetOwner() == c
end
