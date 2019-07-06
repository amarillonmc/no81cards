--左右互搏
function c33700141.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33700141.condition)
	e1:SetTarget(c33700141.target)
	e1:SetOperation(c33700141.activate)
	c:RegisterEffect(e1)
end
function c33700141.cfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c33700141.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33700141.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c33700141.ntrfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsControlerCanBeChanged()
end
function c33700141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33700141.ntrfilter(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(c33700141.ntrfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c33700141.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,1-tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c33700141.ftarget)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
end
end
function c33700141.ftarget(e,c)
	return c:IsType(TYPE_TOKEN)
end
