--倭建命的气兵神殿
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end

function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE + PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND, 0)
	e3:SetCondition(s.imcon)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
end


function s.thfilter(c)
	return c:IsCode(40020585) and c:IsAbleToHand()
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
	if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = g:Select(tp, 1, 1, nil)
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, sg)
	end
end

function s.xyzchk(c)
	return s.ForceFighter(c) and c:IsType(TYPE_XYZ)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == tp 
		and not Duel.IsExistingMatchingCard(s.xyzchk, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.spfilter(c, e, tp)
	return s.ForceFighter(c) and c:IsRank(4) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e, 0, tp, true, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)

	if chk == 0 then return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	local sc = g:GetFirst()
	
	if sc and Duel.SpecialSummon(sc, 0, tp, tp, true, false, POS_FACEUP) > 0 then
		if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_SZONE) then
			Duel.Overlay(sc, Group.FromCards(c))
		end
	end
end

function s.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(), LOCATION_HAND, 0) <= 5
end

function s.efilter(e, re)
	return e:GetHandlerPlayer() ~= re:GetOwnerPlayer()
end
