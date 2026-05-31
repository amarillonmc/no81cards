--癔动囚徒 维尔
function c71280040.initial_effect(c)
	c:SetUniqueOnField(1,0,71280040)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71280040,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(c71280040.target)
	e1:SetOperation(c71280040.operation)
	c:RegisterEffect(e1)
end
function c71280040.cfilter(c,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x8911) and Duel.GetMZoneCount(tp,c)>0
end
function c71280040.spfilter(c,e,tp)
	return c:IsSetCard(0x8911) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c71280040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c71280040.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp)
	if chk==0 then return #g>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,71280040)==0 end
	Duel.RegisterFlagEffect(tp,71280040,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71280040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c71280040.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,4,aux.ExceptThisCard(e),tp)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if ct>=2 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 then
			local dgtc=Duel.GetDecktopGroup(tp,1):GetFirst()
			local dgbc=Duel.GetFieldCard(tp,LOCATION_DECK,0)
			if (dgtc:IsDestructable(e) or dgbc:IsDestructable(e))
				and Duel.SelectYesNo(tp,aux.Stringid(71280040,1)) then
				Duel.BreakEffect()
				if dgtc:IsDestructable(e) then 
					Duel.DisableShuffleCheck()
					Duel.ConfirmCards(tp,dgtc)
					Duel.ConfirmCards(1-tp,dgtc)
					Duel.Destroy(dgtc,REASON_EFFECT)
				end
				if dgbc:IsDestructable(e) then 
					Duel.DisableShuffleCheck()
					Duel.ConfirmCards(tp,dgbc)
					Duel.ConfirmCards(1-tp,dgbc)
					Duel.Destroy(dgbc,REASON_EFFECT)
				end
			end
		end
		if ct>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71280040.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(71280040,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280040.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		if ct>=4 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(71280040,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
			if dg:GetCount()>0 then
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end