--沧海姬 莱洛凡
function c9911007.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911007)
	e1:SetCondition(c9911007.spcon1)
	e1:SetCost(c9911007.spcost)
	e1:SetTarget(c9911007.sptg)
	e1:SetOperation(c9911007.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911007.spcon2)
	c:RegisterEffect(e2)
	--change attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911008)
	e3:SetCondition(c9911007.attcon)
	e3:SetTarget(c9911007.atttg)
	e3:SetOperation(c9911007.attop)
	c:RegisterEffect(e3)
end
function c9911007.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911007.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911007.attfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetReleaseGroup(tp,true):Filter(aux.TRUE,c)
	if chk==0 then return rg:CheckSubGroup(aux.mzctcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,aux.mzctcheck,false,2,2,tp)
	local label=0
	if g:FilterCount(c9911007.attfilter,nil)==2 then label=1 end
	e:SetLabel(label)
	Duel.Release(g,REASON_COST)
end
function c9911007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	end
end
function c9911007.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9911007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c9911007.desfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911007,0)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c9911007.desfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9911007.attcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9911007.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_EARTH) end
end
function c9911007.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9911007.negcon)
		e2:SetOperation(c9911007.negop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c9911007.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and Duel.GetFlagEffect(tp,9911007)<1
end
function c9911007.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9911007,1)) then return end
	Duel.Hint(HINT_CARD,0,9911007)
	Duel.RegisterFlagEffect(tp,9911007,RESET_PHASE+PHASE_END,0,1)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
