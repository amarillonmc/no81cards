--沧海姬的冻封
function c9911015.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9911015.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c9911015.condition)
	e2:SetTarget(c9911015.target)
	e2:SetOperation(c9911015.operation)
	c:RegisterEffect(e2)
end
function c9911015.cfilter(c)
	return c:IsSetCard(0x6954) and c:IsDiscardable(REASON_EFFECT)
end
function c9911015.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9911015.cfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g1>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9911015,0))
		and Duel.DiscardHand(tp,c9911015.cfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=g2:Select(tp,1,2,nil)
		if #sg==0 then return end
		Duel.HintSelection(sg)
		if Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)==0 or Duel.GetFlagEffect(tp,9911015)~=0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6954))
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,9911015,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911015.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function c9911015.filter1(c,e,tp)
	if not c:IsSetCard(0x6954) or not c:IsType(TYPE_MONSTER) then return false end
	return c:IsAbleToHand() or (Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9911015.filter2(c)
	if not c:IsSetCard(0x6954) or not c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsCode(9911015) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c9911015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if Duel.GetFlagEffect(tp,9911016)~=0 then loc=loc-LOCATION_DECK end
	if Duel.GetFlagEffect(tp,9911017)~=0 then loc=loc-LOCATION_GRAVE end
	local b1=Duel.IsExistingMatchingCard(c9911015.filter1,tp,loc,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c9911015.filter2,tp,loc,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function c9911015.operation(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if Duel.GetFlagEffect(tp,9911016)~=0 then loc=loc-LOCATION_DECK end
	if Duel.GetFlagEffect(tp,9911017)~=0 then loc=loc-LOCATION_GRAVE end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911015.filter1),tp,loc,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911015.filter2),tp,loc,0,nil)
	local op=0
	if #g1>0 and #g2>0 then op=Duel.SelectOption(tp,aux.Stringid(9911015,1),aux.Stringid(9911015,2))
	elseif #g1>0 then op=Duel.SelectOption(tp,aux.Stringid(9911015,1))
	elseif #g2>0 then op=Duel.SelectOption(tp,aux.Stringid(9911015,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		local res1=0
		local res2=tc:GetLocation()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				res1=Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				res1=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		if res1>0 then
			if res2==LOCATION_DECK then Duel.RegisterFlagEffect(tp,9911016,RESET_PHASE+PHASE_END,0,1) end
			if res2==LOCATION_GRAVE then Duel.RegisterFlagEffect(tp,9911017,RESET_PHASE+PHASE_END,0,1) end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		local res1=0
		local res2=tc:GetLocation()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
				res1=Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				res1=Duel.SSet(tp,tc)
			end
		end
		if res1>0 then
			if res2==LOCATION_DECK then Duel.RegisterFlagEffect(tp,9911016,RESET_PHASE+PHASE_END,0,1) end
			if res2==LOCATION_GRAVE then Duel.RegisterFlagEffect(tp,9911017,RESET_PHASE+PHASE_END,0,1) end
		end
	end
end
