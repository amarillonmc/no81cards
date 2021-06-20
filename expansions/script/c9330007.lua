--陷阵营首领
function c9330007.initial_effect(c)
	aux.AddCodeList(c,9330001)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,9330001,LOCATION_MZONE+LOCATION_GRAVE)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9330007.efilter)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)
	--can not be Negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c9330007.effectfilter)
	c:RegisterEffect(e5)
	--destory
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9330007,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c9330007.actcon)
	e6:SetTarget(c9330007.target)
	e6:SetOperation(c9330007.actop)
	c:RegisterEffect(e6)
	--effect gain
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e7:SetCondition(c9330007.effcon)
	e7:SetOperation(c9330007.effop)
	c:RegisterEffect(e7)
end
function c9330007.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and not te:GetOwner():IsSetCard(0xaf93)
end
function c9330007.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0xaf93)
end
function c9330007.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLevelAbove(7)
end
function c9330007.filter(c)
	return not (c:IsFaceup() and c:IsType(TYPE_TRAP)) and not c:IsCode(9330001)
end
function c9330007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c9330007.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9330007,0))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9330007.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or c:IsLevelBelow(6) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-3)
	c:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c9330007.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c9330007.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION+REASON_SYNCHRO)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():GetReasonCard():IsSetCard(0xaf93)
end
function c9330007.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e6=Effect.CreateEffect(rc)
	local e2=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9330007,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c9330007.actcon)
	e6:SetTarget(c9330007.target)
	e6:SetOperation(c9330007.actop)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e6,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end













