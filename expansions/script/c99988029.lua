--亡语教徒 背德的女子
function c99988029.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99988029,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,99988029)
	e1:SetTarget(c99988029.target)
	e1:SetOperation(c99988029.operation)
	c:RegisterEffect(e1)	
end
function c99988029.tgfilter(c)
	return c:IsSetCard(0x20df) and c:IsAbleToGrave()
end
function c99988029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99988029.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		local c=e:GetHandler()
	if re and re:GetHandler():IsSetCard(0x20df) and c:IsReason(REASON_EFFECT) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c99988029.thfilter(c)
	return c:IsSetCard(0x20df) and c:IsAbleToHand()
end
function c99988029.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99988029.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT) and e:GetLabel()==1
	and Duel.IsExistingMatchingCard(c99988029.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99988029,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c99988029.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end