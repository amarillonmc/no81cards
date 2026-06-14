--源者契约
function c11182335.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,11182335)
	e1:SetTarget(c11182335.thtg)
	e1:SetOperation(c11182335.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11182335+1)
	e2:SetCost(c11182335.DisCardCost)
	e2:SetTarget(c11182335.thtg2)
	e2:SetOperation(c11182335.thop2)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c11182335.reccon)
	e3:SetOperation(c11182335.recop)
	c:RegisterEffect(e3)
end
function c11182335.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6454)
end
function c11182335.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11182335.cfilter,1,nil)
end
function c11182335.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11182335)
	Duel.Recover(tp,500,REASON_EFFECT)
end
function c11182335.DisCardCostFilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp)
end
function c11182335.DisCardCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182335.DisCardCostFilter,tp,0x30,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(11182305,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c11182335.thfilter2(c)
	return c:IsSetCard(0x6454) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c11182335.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182335.thfilter2,tp,0x30,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end
function c11182335.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11182335.thfilter2),tp,0x30,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(11182335,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				if dg:GetCount()>0 then
					Duel.BreakEffect()
					Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
				end
			end
		end
	end
end
function c11182335.thfilter(c)
	return c:IsSetCard(0x6454) and c:IsAbleToHand()
end
function c11182335.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182335.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11182335.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11182335.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.SelectYesNo(tp,aux.Stringid(11182335,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			if dg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end