--人理之诗 咆哮吧！吾之愤怒！
function c22020780.initial_effect(c)
	aux.AddCodeList(c,22020770)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,22020780+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22020780.cost)
	e1:SetCondition(c22020780.condition)
	e1:SetTarget(c22020780.target)
	e1:SetOperation(c22020780.activate)
	c:RegisterEffect(e1)
end
function c22020780.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22020780,0))
end
function c22020780.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c22020780.filter(c)
	return c:IsCode(22020770) and c:IsFaceup()
end
function c22020780.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020780.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c22020780.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SelectOption(tp,aux.Stringid(22020780,1))
	Duel.Destroy(eg,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c22020780.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SelectOption(tp,aux.Stringid(22020780,2))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22020780.discon)
		e1:SetOperation(c22020780.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22020780.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffect(22020780)==0 and ep~=tp
end
function c22020780.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:GetHandler():RegisterFlagEffect(22020780,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end