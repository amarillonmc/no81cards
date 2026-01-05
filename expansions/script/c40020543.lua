--似神者史莱姆
local s, id = GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,10000010, 15771991, 83764718)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 100 + EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.lpcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.lptg)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
end

function s.ra_filter(c)
	return c:IsCode(10000010) and not c:IsPublic()
end

function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local b1 = Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 10000010)
	local b2 = Duel.IsExistingMatchingCard(s.ra_filter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, nil)
	
	if chk == 0 then return b1 or b2 end
	
	local confirm = false
	if b2 and (not b1 or Duel.SelectYesNo(tp, aux.Stringid(id, 2))) then
		confirm = true
	end
	
	if confirm then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
		local g = Duel.SelectMatchingCard(tp, s.ra_filter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, 1, nil)
		Duel.ConfirmCards(1 - tp, g)
		e:SetLabelObject(g:GetFirst())
		if g:GetFirst():IsLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
	else
		e:SetLabelObject(nil)
	end
end

function s.gs_filter(c, e, tp)
	return c:IsCode(15771991) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2
			and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingMatchingCard(s.gs_filter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 0, tp, LOCATION_HAND + LOCATION_DECK)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end
	if not c:IsRelateToEffect(e) then return end
	
	local g = Duel.GetMatchingGroup(s.gs_filter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE, 0, nil, e, tp)
	if #g > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local sg = g:Select(tp, 1, 1, nil)
		sg:AddCard(c)
		if Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP) > 0 then
			local rc = e:GetLabelObject()
			if rc then
				Duel.BreakEffect()
				Duel.SendtoDeck(rc, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
			end
		end
	end
end

function s.lpcon(e, tp, eg, ep, ev, re, r, rp)
	local b1 = Duel.IsExistingMatchingCard(Card.IsRace, tp, LOCATION_MZONE, 0, 1, nil, RACE_DIVINE)
	local b2 = Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0 
		   and Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE) > 0
	return b1 or b2
end

function s.mr_filter(c)
	return c:IsCode(83764718) and c:IsAbleToHand()
end

function s.ra_search_filter(c)
	return (c:IsCode(10000010) or aux.IsCodeListed(c, 10000010)) 
		   and not c:IsCode(id) and c:IsAbleToHand()
end

function s.lptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end 
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 0, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.lpop(e, tp, eg, ep, ev, re, r, rp)
	Duel.SetLP(tp, 4100)
	
	local g = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mr_filter), tp, LOCATION_DECK + LOCATION_GRAVE, 0, nil)
	if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = g:Select(tp, 1, 1, nil)
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, sg)
	end
	
	if Duel.GetFieldGroupCount(tp, LOCATION_ONFIELD, 0) == 0 then
		local g2 = Duel.GetMatchingGroup(s.ra_search_filter, tp, LOCATION_DECK, 0, nil)
		if #g2 > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg2 = g2:Select(tp, 1, 1, nil)
			Duel.SendtoHand(sg2, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, sg2)
		end
	end
end
