--溶星蝎 流星广翅鲎
local s,id=GetID()

s.named_with_LavaAstral=1
function s.LavaAstral(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_LavaAstral
end


function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)


	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0, TIMING_BATTLE_START + TIMING_BATTLE_END)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

function s.e1cost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c, REASON_COST + REASON_DISCARD)
end

function s.tgfilter(c)
	return (c:IsCode(40020321) or s.LavaAstral(c)) and not c:IsCode(id) and c:IsAbleToGrave()
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoGrave(g, REASON_EFFECT)
	end
end

function s.e2con(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer() == 1 - tp and (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE)
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.pcfilter(c)
	return c:IsCode(40020321) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and not c:IsForbidden()
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		if Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1) then
			local g = Duel.GetMatchingGroup(s.pcfilter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, nil)
			if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
				local sg = g:Select(tp, 1, 1, nil)
				local tc = sg:GetFirst()
				if tc then
					Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
				end
			end
		end
	end
end