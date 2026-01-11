--气兵墓场
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end
function s.initial_effect(c)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.actcon)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0, 1) 
	e2:SetCondition(s.taxcon)
	e2:SetCost(s.costchk)
	e2:SetOperation(s.costop)
	c:RegisterEffect(e2)
end

function s.yamatofilter(c)
	return c:IsFaceup() and c:IsCode(40020585)
end

function s.actcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.yamatofilter, tp, LOCATION_PZONE, 0, 1, nil)
end

function s.thfilter(c)
	return s.ForceFighter(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.acttg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_HAND)
end

function s.actop(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
	if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)

		local sg = g:Select(tp, 1, 1, nil)
		local tc1 = sg:GetFirst()

		g:Remove(Card.IsCode, nil, tc1:GetCode())
		if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg2 = g:Select(tp, 1, 1, nil)
			sg:Merge(sg2)
		end
		
		if sg:GetCount() > 0 then
			if Duel.SendtoHand(sg, nil, REASON_EFFECT) > 0 then
				Duel.ConfirmCards(1 - tp, sg)
				Duel.ShuffleHand(tp)
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
				local tg = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, LOCATION_HAND, 0, 1, 1, nil)
				if tg:GetCount() > 0 then
					Duel.SendtoDeck(tg, nil, SEQ_DECKBOTTOM, REASON_EFFECT)
				end
			end
		end
	end
end

function s.badgyfilter(c)
	return not (c:IsCode(40020585) or s.ForceFighter(c))
end

function s.taxcon(e)
	local tp = e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(s.badgyfilter, tp, LOCATION_GRAVE, 0, 1, nil)
end

function s.costchk(e, te, tp)
	return Duel.CheckLPCost(tp, 800)
end

function s.costop(e, tp, eg, ep, ev, re, r, rp)
	Duel.PayLPCost(tp, 800)
end
