--兄弟会之毅
function c40009637.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009637,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c40009637.discon)
	e1:SetTarget(c40009637.distg)
	e1:SetOperation(c40009637.disop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c40009637.setcost)
	e2:SetTarget(c40009637.settg)
	e2:SetOperation(c40009637.setop)
	c:RegisterEffect(e2)   
end
function c40009637.disfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcf1b) and c:IsLevelAbove(5)
end
function c40009637.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c40009637.disfilter,tp,LOCATION_MZONE,0,2,e:GetHandler())
end
function c40009637.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(40009637,1))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(40009637,1))
	Duel.RegisterFlagEffect(tp,40009560,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c40009637.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c40009637.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c40009637.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009637.cfilter,tp,LOCATION_EXTRA,0,3,nil) end
	local g=Duel.GetMatchingGroup(c40009637.cfilter,tp,LOCATION_EXTRA,0,nil)
	local rg=g:RandomSelect(tp,3)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c40009637.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c40009637.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end