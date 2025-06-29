--禁钉迹观升天
function c20250346.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,20250346)
	e1:SetCondition(c20250346.condition)
	e1:SetTarget(c20250346.target)
	e1:SetOperation(c20250346.activate)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,20250347)
	e2:SetCost(c20250346.sycost)
	e2:SetTarget(c20250346.syntg)
	e2:SetOperation(c20250346.synop)
	c:RegisterEffect(e2)
end
function c20250346.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x54a) and c:IsType(TYPE_SYNCHRO)
end
function c20250346.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	and Duel.IsExistingMatchingCard(c20250346.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20250346.filter(c,tp)
	return c:GetCounter(0x154a)>0
end
function c20250346.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20250346.filter,rp,0,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
end
function c20250346.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c20250346.repop)
end
function c20250346.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(1-tp,c20250346.filter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local ct=tc:GetCounter(0x154a)
		tc:RemoveCounter(tp,0x154a,ct,REASON_EFFECT)
	end
end
function c20250346.sycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c20250346.mfilter(c)
	return c:IsSetCard(0x54a) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c20250346.syncheck(g,tp,syncard)
	return g:IsExists(c20250346.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c20250346.spfilter(c,tp,mg)
	return mg:CheckSubGroup(c20250346.syncheck,2,#mg,tp,c)
end
function c20250346.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		return Duel.IsExistingMatchingCard(c20250346.spfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c20250346.synop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local g=Duel.GetMatchingGroup(c20250346.spfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,c20250346.syncheck,false,2,#mg,tp,sc)
		Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
	end
end