--月神的牵绊
function c9910066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910066+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910066.cost)
	e1:SetTarget(c9910066.target)
	e1:SetOperation(c9910066.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910066,ACTIVITY_SPSUMMON,c9910066.counterfilter)
end
function c9910066.counterfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c9910066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9910066,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c9910066.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9910066.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_FAIRY)
end
function c9910066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp)==5 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c9910066.setfilter(c,e,tp)
	if not c:IsSetCard(0x9951) then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else return not c:IsCode(9910066) and c:IsSSetable() end
end
function c9910066.spfilter(c,e,tp)
	return c:IsSetCard(0x9951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910066.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>5 then ct=5 end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.DisableShuffleCheck(false)
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if og:GetCount()==0 then return end
	Duel.HintSelection(og)
	local ct2=og:Filter(Card.IsRace,nil,RACE_FAIRY):GetClassCount(Card.GetAttribute)
	if ct2>0 and Duel.IsExistingMatchingCard(c9910066.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(9910066,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg1=Duel.SelectMatchingCard(tp,c9910066.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc1=sg1:GetFirst()
		if tc1 then
			if tc1:IsType(TYPE_MONSTER) then
				res=Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				if res~=0 then Duel.ConfirmCards(1-tp,tc1) end
			else
				if Duel.SSet(tp,tc1)~=0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(9910066,2))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetDescription(aux.Stringid(9910066,2))
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e2)
				end
			end
		end
		ct2=ct2-1
	end
	if ct2>0 and Duel.IsExistingMatchingCard(c9910066.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(9910066,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(tp,c9910066.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc2=sg2:GetFirst()
		if tc2 and Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			tc2:RegisterEffect(e1)
		end
	end
end
