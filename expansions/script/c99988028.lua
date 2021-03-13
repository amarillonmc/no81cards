--恶念化 地狱传教士
function c99988028.initial_effect(c)
	--trol
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99988028,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,99988028)
	e1:SetTarget(c99988028.target)
	e1:SetOperation(c99988028.operation)
	c:RegisterEffect(e1)	
end
function c99988028.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c99988028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99988028.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
	local c=e:GetHandler()
	if re and re:GetHandler():IsSetCard(0x20df) and c:IsReason(REASON_EFFECT) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c99988028.thfilter(c)
	return not c:IsCode(99988028) and c:IsSetCard(0x20df) and c:IsAbleToHand()
end
function c99988028.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c99988028.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.GetControl(tc,tp,PHASE_END,1) and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c99988028.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99988028,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c99988028.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g2>0 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end