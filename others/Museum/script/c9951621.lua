--翱翔于天际的伊莉雅
function c9951621.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9951621.target)
	e1:SetOperation(c9951621.operation)
	c:RegisterEffect(e1)
end
function c9951621.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xaba8)
end
function c9951621.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9951621.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951621.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9951621.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9951621.disfilter(e,c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0xab8)
end
function c9951621.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTarget(c9951621.disfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetTarget(c9951621.disfilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		 Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c9951621.imfilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c9951621.imfilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetOwner()~=e:GetOwner()
end

