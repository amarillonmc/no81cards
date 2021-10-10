--魔戒仪士传承刻印-牙狼
function c82599993.initial_effect(c)
	c:EnableReviveLimit()
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c82599993.mtcon)
	e1:SetOperation(c82599993.mtop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,82599993)
	e2:SetCondition(c82599993.negcon)
	e2:SetCost(c82599993.negcost)
	e2:SetTarget(c82599993.negtg)
	e2:SetOperation(c82599993.negop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c82599993.atkup)
	c:RegisterEffect(e3)
	--immume
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c82599993.efilter)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,82599893)
	e5:SetTarget(c82599993.dmtg)
	e5:SetOperation(c82599993.dmop)
	c:RegisterEffect(e5)
end
function c82599993.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dmg=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)*500
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dmg)
end
function c82599993.dmop(e,tp,eg,ep,ev,re,r,rp)
	local dmg=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)*500
		Duel.Damage(1-tp,dmg,REASON_EFFECT)
end
function c82599993.grfilter2(c,e,tp)
	return c:IsSetCard(0x821) and c:IsType(TYPE_MONSTER)
end
function c82599993.atkup(e,c)
	return Duel.GetMatchingGroupCount(c82599993.grfilter2,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end
function c82599993.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner() and  te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82599993.ngfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x821)
end
function c82599993.negcon(e,tp,eg,ep,ev,re,r,rp)
	if  re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c82599993.ngfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
	else return false end
end
function c82599993.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() 
end
end
function c82599993.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c82599993.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
end
end
function c82599993.grfilter(c,e,tp)
	return c:IsSetCard(0x821) and c:IsAbleToRemoveAsCost()
end
function c82599993.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c82599993.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c82599992.grfilter,tp,LOCATION_GRAVE,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82599993.grfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	 if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	 else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	 end
	else
		Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
	end
end
