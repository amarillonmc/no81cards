--地中族的凶斗
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.posfilter1(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsLevelBelow(4)
		and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
end
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0xed) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.posfilter2(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsLevelAbove(5)
		and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0xed) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.posfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.posfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and (s.posfilter1(chkc,e,tp) or s.posfilter2(chkc,e,tp)) end
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	e:SetLabel(op)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Group.CreateGroup()
	if op==0 then
		g=Duel.SelectTarget(tp,s.posfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		g=Duel.SelectTarget(tp,s.posfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc1=Duel.GetFirstTarget()
		if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and Duel.ChangePosition(tc1,POS_FACEDOWN_DEFENSE)>0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	else
		local tc1=Duel.GetFirstTarget()
		if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and Duel.ChangePosition(tc1,POS_FACEDOWN_DEFENSE)>0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
