--沧海姬 尼尔巴伦
function c9911009.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911009)
	e1:SetCondition(c9911009.spcon1)
	e1:SetCost(c9911009.spcost)
	e1:SetTarget(c9911009.sptg)
	e1:SetOperation(c9911009.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911009.spcon2)
	c:RegisterEffect(e2)
	--change attribute
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911010)
	e3:SetCondition(c9911009.attcon)
	e3:SetTarget(c9911009.atttg)
	e3:SetOperation(c9911009.attop)
	c:RegisterEffect(e3)
end
function c9911009.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911009.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911009.cfilter(c,tp,mc)
	local b1=c:IsLocation(LOCATION_HAND+LOCATION_MZONE)
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.IsPlayerAffectedByEffect(tp,9911013)
		and Duel.GetFlagEffect(tp,9911013)==0 and mc:IsLevelAbove(0) and c:IsLevelAbove(mc:GetLevel()+1)
	return (b1 or b2) and c:IsReleasable()
end
function c9911009.gselect(g,tp)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1 and Duel.GetMZoneCount(tp,g)>0
end
function c9911009.attfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9911009.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,c,tp,c)
	if chk==0 then return g:CheckSubGroup(c9911009.gselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c9911009.gselect,false,2,2,tp)
	local label=0
	if rg:IsExists(c9911009.attfilter,2,nil) then label=1 end
	if rg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
		Duel.RegisterFlagEffect(tp,9911013,RESET_PHASE+PHASE_END,0,0)
	end
	e:SetLabel(label)
	Duel.SendtoGrave(rg,REASON_RELEASE+REASON_COST)
end
function c9911009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	end
end
function c9911009.desfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9911009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c9911009.desfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911009,0)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c9911009.desfilter,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9911009.attcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9911009.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_EARTH) end
end
function c9911009.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9911009,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
			end
		end
	end
end
