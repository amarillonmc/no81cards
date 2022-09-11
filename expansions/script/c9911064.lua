--恋慕屋敷的军姬
function c9911064.initial_effect(c)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c9911064.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c9911064.rmtg)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9911064)
	e4:SetTarget(c9911064.destg)
	e4:SetOperation(c9911064.desop1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c9911064.descon)
	e5:SetCost(c9911064.descost)
	e5:SetOperation(c9911064.desop2)
	c:RegisterEffect(e5)
end
function c9911064.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1954)*200
end
function c9911064.rmtg(e,c)
	return c:IsFaceup() and c:GetCounter(0x1954)>0
end
function c9911064.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9911064.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9911064.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9911064.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1954,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1954,4,REASON_COST)
end
function c9911064.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(9911064,0)) then
		Duel.BreakEffect()
		Duel.NegateEffect(ev)
	end
end
