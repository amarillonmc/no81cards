--幽鬼兔 木叶咲耶
function c9910258.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910258)
	e1:SetCondition(c9910258.condition)
	e1:SetCost(c9910258.cost)
	e1:SetOperation(c9910258.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910259)
	e2:SetCost(c9910258.rmcost)
	e2:SetTarget(c9910258.rmtg)
	e2:SetOperation(c9910258.rmop)
	c:RegisterEffect(e2)
end
function c9910258.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa956)
end
function c9910258.condition(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp~=tp and tc:IsRelateToEffect(te) and tc:IsFaceup() and tc:IsStatus(STATUS_EFFECT_ENABLED)
			and not tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
			res=true
		end
	end
	return res and Duel.IsExistingMatchingCard(c9910258.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9910258.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910258.operation(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetCondition(c9910258.descon)
	e2:SetOperation(c9910258.desop)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c9910258.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c9910258.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsFaceup() and rc:IsStatus(STATUS_EFFECT_ENABLED)
		and not rc:IsStatus(STATUS_LEAVE_CONFIRMED) then
		Duel.Hint(HINT_CARD,0,9910258)
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c9910258.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsCanRemoveCounter(tp,1,1,0x956,4,REASON_COST) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RemoveCounter(tp,1,1,0x956,4,REASON_COST)
end
function c9910258.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c9910258.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910258.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c9910258.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910258.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
