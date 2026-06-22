--超越星反射
local s, id = GetID()
function s.initial_effect(c)   
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DISABLE + CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 4))
	e2:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end


function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter, e:GetHandlerPlayer(), LOCATION_SZONE, 0, 1, nil)
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(45055659) 
end

function s.condition1(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.mfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.mfilter(c)
	return c:IsSetCard(0x6f5) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function s.target1(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.operation1(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 1))
		local op = Duel.SelectOption(tp, 
			aux.Stringid(id, 2), 
			aux.Stringid(id, 3)  
		)
		
		if op == 0 then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			tc:RegisterEffect(e1)
			local e2 = Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			tc:RegisterEffect(e2)
		else
			Duel.Destroy(tc, REASON_EFFECT)
		end
	end
end

function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function s.filter2(c)
	return c:IsSetCard(0x6f5) and c:IsAbleToDeck()
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return false end
	if chk == 0 then 
		return Duel.IsExistingTarget(s.filter2, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 3, e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, s.filter2, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 3, 3, e:GetHandler())
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 3, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.operation2(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect, nil, e)
	if g:GetCount() == 3 then
		Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		if g:IsExists(Card.IsLocation, 1, nil, LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp, 1, REASON_EFFECT)
		end
	end
end