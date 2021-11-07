--铭盟军 凯恩士兵
function c19015.initial_effect(c)
		--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19015,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c19015.condition)
	e2:SetTarget(c19015.target)
	e2:SetOperation(c19015.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e2:SetDescription(aux.Stringid(19015,1))
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,19015)
	e3:SetCost(c19015.cost)
	c:RegisterEffect(e3)
end
	function c19015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
	function c19015.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x888) and not c:IsHasEffect(EFFECT_PIERCE)
end
	function c19015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c19015.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19015.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
	function c19015.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
	function c19015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
