local m=31400139
local cm=_G["c"..m]
cm.name="星尘幻想衍生物"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.discon1)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.discon2)
	c:RegisterEffect(e1)
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and c:IsLevelAbove(10)
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and c:IsLevelAbove(12)
end
function cm.excostfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(84012625,tp)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	if e:GetHandler():IsReleasable() then g:AddCard(e:GetHandler()) end
	if chk==0 then return #g>0 end
	local tc
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(84012625,0))
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	local te=tc:IsHasEffect(84012625,tp)
	if te then
		Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end