--光子降临者
local s, id = GetID()

function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon1)
	e1:SetCost(s.spcost1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(s.spcost2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end

function s.spcon1(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
end

function s.spcost1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1 - tp, e:GetHandler())
end

function s.spfilter1(c, e, tp)
	return (c:IsSetCard(0x7b) or c:IsSetCard(0x55)) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.thfilter(c)
	return (c:IsSetCard(0x7b) or c:IsSetCard(0x55)) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.sptg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter1, tp, LOCATION_HAND, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.splimit(e, c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end

function s.spop1(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler() 
	
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)

	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter1, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp)
	local tc = g:GetFirst()
	
	if tc and Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then

		if tc == c then
			local g_search = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)

			if #g_search > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)

				local sg = g_search:SelectSubGroup(tp, aux.dncheck, false, 1, 2)
				if sg and #sg > 0 then
					Duel.SendtoHand(sg, nil, REASON_EFFECT)
					Duel.ConfirmCards(1 - tp, sg)
					Duel.ShuffleHand(tp)
					
					Duel.BreakEffect()
					Duel.DiscardHand(tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD)
				end
			end
		end
	end
end


function s.costfilter(c)
	return c:IsSetCard(0x7b) and c:IsDiscardable()
end

function s.spcost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_HAND, 0, 1, nil) end
	Duel.DiscardHand(tp, s.costfilter, 1, 1, REASON_COST + REASON_DISCARD)
end

function s.spfilter2(c, e, tp)
	return c:IsSetCard(0x107b) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter2, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end
