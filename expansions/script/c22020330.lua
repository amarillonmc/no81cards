--人理之诗 骑英之缰绳
function c22020330.initial_effect(c)
	aux.AddCodeList(c,22020320)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020330,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,22020330)
	e1:SetCost(c22020330.cost)
	e1:SetCondition(c22020330.condition)
	e1:SetTarget(c22020330.target)
	e1:SetOperation(c22020330.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020330,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22020330)
	e2:SetCondition(c22020330.spcon)
	e2:SetTarget(c22020330.sptg)
	e2:SetOperation(c22020330.spop)
	c:RegisterEffect(e2)
end
function c22020330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020330,2))
end
function c22020330.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND)
end
function c22020330.filter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22020330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020330.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c22020330.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c22020330.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22020330.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.SelectOption(tp,aux.Stringid(22020330,3))
	if ct>0 and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
	end
end
function c22020330.ctfilter(c)
	return c:IsFaceup() and c:IsCode(22020320)
end
function c22020330.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020330.ctfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22020330.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22020330)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020330,0xff1,0x11,1200,600,3,RACE_BEAST,ATTRIBUTE_WIND) end
	c:RegisterFlagEffect(22020330,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22020330.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,22020330,0xff1,0x11,1200,600,3,RACE_BEAST,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end