--永无止息的神炎
local s, id = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW + CATEGORY_TOHAND + CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND + LOCATION_SZONE)
	e1:SetCountLimit(1,46047445) 
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,46047445) 
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.target1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local b1=Duel.IsExistingMatchingCard(Card.IsAttribute, tp, LOCATION_HAND, 0, 1, nil, ATTRIBUTE_FIRE) and 
				 Duel.IsPlayerCanDraw(tp, 2)
		local b2=Duel.IsExistingMatchingCard(Card.IsAttribute, tp, LOCATION_MZONE, 0, 1, nil, ATTRIBUTE_FIRE) and 
				 Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, 0, LOCATION_ONFIELD, 1, nil)
		return b1 or b2
	end

	local b1=Duel.IsExistingMatchingCard(Card.IsAttribute, tp, LOCATION_HAND, 0, 1, nil, ATTRIBUTE_FIRE) and 
			 Duel.IsPlayerCanDraw(tp, 2)
	local b2=Duel.IsExistingMatchingCard(Card.IsAttribute, tp, LOCATION_MZONE, 0, 1, nil, ATTRIBUTE_FIRE) and 
			 Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, 0, LOCATION_ONFIELD, 1, nil)
	
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2)},
			{b2,aux.Stringid(id,3)})
	e:SetLabel(op)
	
	if op==1 then
		e:SetCategory(CATEGORY_DRAW + CATEGORY_TOGRAVE)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
		Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_TODECK + CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 1-tp, LOCATION_ONFIELD)
		Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_MZONE)
	end
end
function s.activate1(e, tp, eg, ep, ev, re, r, rp) 
	local c = e:GetHandler()
	
	local op = e:GetLabel()
	
	if op == 1 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local g = Duel.SelectMatchingCard(tp, Card.IsAttribute, tp, LOCATION_HAND, 0, 1, 1, nil, ATTRIBUTE_FIRE)
		if #g > 0 and Duel.SendtoGrave(g, REASON_EFFECT) > 0 then
			local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
			Duel.Draw(p, d, REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local g1 = Duel.SelectMatchingCard(tp, Card.IsAttribute, tp, LOCATION_MZONE, 0, 1, 1, nil, ATTRIBUTE_FIRE)
		if #g1 > 0 and Duel.SendtoGrave(g1, REASON_EFFECT) > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
			local g2 = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
			if #g2 > 0 then
				Duel.SendtoDeck(g2, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
			end
		end
	end
end
function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c, POS_FACEUP, REASON_COST)
end
function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function s.activate2(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end
function s.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevel(8) and not c:IsSummonableCard()
end