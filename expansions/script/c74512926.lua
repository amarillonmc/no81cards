--人偶·阿卡赛特
function c74512926.initial_effect(c)
	aux.EnableDualAttribute(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74512926,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c74512926.discon1)
	e1:SetCost(c74512926.cost1)
	e1:SetTarget(c74512926.distg)
	e1:SetOperation(c74512926.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c74512926.discon2)
	e2:SetCost(c74512926.cost2)
	c:RegisterEffect(e2)
end
function c74512926.discon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and rp==1-tp and Duel.IsChainNegatable(ev) and not Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74512926.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c74512926.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and rp==1-tp and Duel.IsChainNegatable(ev) and aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74512926.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(tp,1000,REASON_COST)
end
function c74512926.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c74512926.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
