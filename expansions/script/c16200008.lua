--单推单推单推人
function c16200008.initial_effect(c)
	aux.AddCodeList(c,16200003)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c16200008.condition1)
	e1:SetCost(c16200008.cost1)
	e1:SetTarget(c16200008.target1)
	e1:SetOperation(c16200008.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c16200008.condition2)
	e4:SetCost(c16200008.cost2)
	e4:SetTarget(c16200008.target2)
	e4:SetOperation(c16200008.activate2)
	c:RegisterEffect(e4)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c16200008.handcon)
	c:RegisterEffect(e0)
end
function c16200008.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c16200008.handcon(e)
	return not Duel.IsExistingMatchingCard(c16200008.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c16200008.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c16200008.pfilter(c)
	return aux.IsCodeListed(c,16200003) and not c:IsPublic()
end
function c16200008.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c16200008.pfilter,tp,LOCATION_HAND,0,1,c) and Duel.GetFlagEffect(tp,16200008)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16200008,3))
	local sg=Duel.SelectMatchingCard(tp,c16200008.pfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,sg)
	Duel.RegisterFlagEffect(tp,tp,16200008,RESET_PHASE+PHASE_END,0,1)
end
function c16200008.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c16200008.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,16200007)~=0 then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,tp,16200007,RESET_PHASE+PHASE_END,0,1)
end
function c16200008.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c16200008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c16200008.pfilter,tp,LOCATION_HAND,0,1,c) and Duel.GetFlagEffect(tp,16200009)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16200008,3))
	local sg=Duel.SelectMatchingCard(tp,c16200008.pfilter,tp,LOCATION_HAND,1,1,c)
	Duel.ConfirmCards(1-tp,sg)
	Duel.RegisterFlagEffect(tp,tp,16200009,RESET_PHASE+PHASE_END,0,1)
end
function c16200008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16200008.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,16200006)~=0 then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,tp,16200006,RESET_PHASE+PHASE_END,0,1)
	end
end