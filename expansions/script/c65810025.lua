--盛夏回忆·生机
function c65810025.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65810025+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65810025.cost)
	e1:SetTarget(c65810025.target)
	e1:SetOperation(c65810025.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65810025,ACTIVITY_SUMMON,c65810025.counterfilter)
	Duel.AddCustomActivityCounter(65810025,ACTIVITY_SPSUMMON,c65810025.counterfilter)
end


--自诉
function c65810025.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
function c65810025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65810025,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(65810025,tp,ACTIVITY_SPSUMMON)==0 end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c65810025.sumlimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c65810025.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end
--检测能否被效果丢弃
function c65810025.filter1(c)
	return c:IsDiscardable(REASON_EFFECT)
end
--检测「盛夏回忆」卡
function c65810025.filter(c)
	return (c:IsSetCard(0xa31) or c:IsRace(RACE_INSECT)) and c:IsAbleToHand()
end
function c65810025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c65810025.filter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c65810025.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--检测可以因效果特招的卡
function c65810025.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65810025.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c65810025.filter1,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		--丢1手
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		--检索
		local g=Duel.SelectMatchingCard(tp,c65810025.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			--那之后有空格子的话
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return 
			end
			local g=Duel.GetMatchingGroup(c65810025.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65810025,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				if sg:GetCount()>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
