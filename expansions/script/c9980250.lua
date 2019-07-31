--异界女神行动
function c9980250.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9980250+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9980250.condition)
	e1:SetTarget(c9980250.target)
	e1:SetOperation(c9980250.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9980250)
	e1:SetCondition(c9980250.adcon)
	e1:SetCost(c9980250.adcost)
	e1:SetTarget(c9980250.adtg)
	e1:SetOperation(c9980250.adop)
	c:RegisterEffect(e1)
end
function c9980250.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc8)
end
function c9980250.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980250.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9980250.filter(c)
	return c:IsFaceup() and c:GetAttack()>0 and c:IsSetCard(0xbc8)
end
function c9980250.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9980250.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980250.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9980250.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack()/2)
end
function c9980250.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)
	end
end
function c9980250.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c9980250.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9980250.adfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5bc8) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c9980250.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980250.adfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980250.adfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9980250.adfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980250.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
