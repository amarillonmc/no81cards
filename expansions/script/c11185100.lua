--星绘·星谛
function c11185100.initial_effect(c)
	aux.AddCodeList(c,0x452)
	c:EnableCounterPermit(0x452)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,11185100)
	e1:SetCondition(c11185100.tgcon)
	e1:SetCost(c11185100.tgcost)
	e1:SetTarget(c11185100.tgtg)
	e1:SetOperation(c11185100.tgop)
	c:RegisterEffect(e1)
	--pzone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11185100,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11185100+1)
	e2:SetCost(c11185100.tfcost)
	e2:SetTarget(c11185100.tftg)
	e2:SetOperation(c11185100.tfop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,11185100+2)
	e3:SetTarget(c11185100.sptg2)
	e3:SetOperation(c11185100.spop2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(11185100,ACTIVITY_SUMMON,c11185100.counterfilter)
	Duel.AddCustomActivityCounter(11185100,ACTIVITY_SPSUMMON,c11185100.counterfilter)
end
function c11185100.counterfilter(c)
	return c:IsRace(RACE_FAIRY) or aux.IsCodeListed(c,0x452)
end
function c11185100.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function c11185100.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11185100,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(11185100,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11185100.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c11185100.splimit(e,c)
	return not (c:IsRace(RACE_FAIRY) or aux.IsCodeListed(c,0x452))
end
function c11185100.tgfilter(c)
	return c:IsSetCard(0x452) and c:IsType(0x1) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c11185100.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185100.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11185100.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11185100,1))
	local g=Duel.SelectMatchingCard(tp,c11185100.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c11185100.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c11185100.tffilter(c)
	return c:IsSetCard(0x452) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c11185100.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185100.tffilter,tp,0x40,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c11185100.ctfilter(c)
	return c:IsSetCard(0x452) and c:IsFaceup() and c:IsCanAddCounter(0x452,1)
end
function c11185100.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11185100.tffilter),tp,0x40,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			local cg=Duel.GetMatchingGroup(c11185100.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(11185100,0)) then
				Duel.BreakEffect()
				local sg=cg:Select(tp,1,1,nil)
				sg:GetFirst():AddCounter(0x452,1)
			end
		end
	end
end
function c11185100.tfilter(c,sc,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x452)
end
function c11185100.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c11185100.tfilter,tp,LOCATION_ONFIELD,0,1,nil,c,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11185100.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c11185100.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil,c,tp)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			if c:IsCanAddCounter(0x452,1) and Duel.SelectYesNo(tp,aux.Stringid(11185100,0)) then
				Duel.BreakEffect()
				c:AddCounter(0x452,1)
			end
		end
	end
end