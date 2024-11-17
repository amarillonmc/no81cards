--盛夏回忆·复苏
function c65810090.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65810090+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65810090.cost)
	e1:SetTarget(c65810090.target)
	e1:SetOperation(c65810090.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65810090,ACTIVITY_SPSUMMON,c65810090.counterfilter)
end



--自诉
function c65810090.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
function c65810090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65810090,tp,ACTIVITY_SPSUMMON)==0 end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c65810090.sumlimit)
	Duel.RegisterEffect(e2,tp)
end
function c65810090.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end


--检测
function c65810090.filter1(c)
	return c:IsAbleToGrave(REASON_EFFECT) and c:IsSetCard(0xa31)
end
function c65810090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c65810090.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c65810090.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65810090.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65810090.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		--那之后有空格子的话
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return 
		end
		local g=Duel.GetMatchingGroup(c65810090.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65810090,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
