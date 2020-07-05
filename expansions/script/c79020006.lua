--危机合约·破坏武装
function c79020006.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c79020006.destg)
	e0:SetOperation(c79020006.desop)
	c:RegisterEffect(e0)   
	--disable 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(73594093,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetTarget(c79020006.tdtg)
	e1:SetOperation(c79020006.tdop)
	e1:SetCost(c79020006.tdcost)
	c:RegisterEffect(e1) 
end
function c79020006.sfilter(c)
	return c:IsSetCard(0x3900) and c:IsType(TYPE_MONSTER)
end
function c79020006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79020006.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79020006.sfilter,tp,LOCATION_MZONE,0,1,nil) end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
  local g=Duel.SelectTarget(tp,c79020006.sfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,q,1,0,0)
end
function c79020006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(c79020006.efilter)
	tc:RegisterEffect(e4)
end
end
function c79020006.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79020006.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79020006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_MZONE)
end
function c79020006.tdop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)
		e4:SetValue(0)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
end
end
