--超古代的传承
function c98930008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98930008)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98930008,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c98930008.thcost)
	e2:SetTarget(c98930008.thtg)
	e2:SetOperation(c98930008.thop)
	c:RegisterEffect(e2)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c98930008.operation)
	c:RegisterEffect(e2)
end
function c98930008.refilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xad0)
end
function c98930008.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c98930008.refilter,nil,nil)
	if ct>0 then
		Duel.Recover(tp,100*ct,REASON_EFFECT)
	end
end
function c98930008.dsfilter(c)
	return c:IsSetCard(0xad0) and c:IsDiscardable()
end
function c98930008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98930008.dsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c98930008.dsfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c98930008.thfilter(c)
	return c:IsSetCard(0xad0) and not c:IsCode(98930008) and (c:IsAbleToHand() and c:IsAbleToGrave())
end
function c98930008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98930008.thfilter,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98930008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
	local g=Duel.SelectMatchingCard(tp,c98930008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0)
		then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end

	