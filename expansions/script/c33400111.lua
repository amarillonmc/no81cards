--刻刻帝 「十一之弹」
function c33400111.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_START)
	e1:SetCost(c33400111.cost)
	e1:SetCondition(c33400111.condition)
	e1:SetTarget(c33400111.target)
	e1:SetOperation(c33400111.activate)
	c:RegisterEffect(e1)
end
function c33400111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsCanRemoveCounter(tp,1,0,0x34f,11,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,11,REASON_COST)
end
function c33400111.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3341)
end
function c33400111.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 or Duel.GetCurrentPhase()~=PHASE_BATTLE_START or Duel.GetTurnPlayer()~=1-tp then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and g:FilterCount(c33400111.cfilter,nil)==g:GetCount()
end
function c33400111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c33400111.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)   
	if Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) then 
		local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
		local tc=g:GetFirst()
		if not tc then return end
		local c=e:GetHandler()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
				tc:RegisterEffect(e3)
			end
			tc=g:GetNext()
		end
   end 
	local tg=Duel.GetMatchingGroup(c33400111.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if tg and Duel.SelectYesNo(tp,aux.Stringid(33400111,0)) and Duel.GetFlagEffect(tp,33400101)>=2 then
	 tc1=tg:Select(tp,1,2,nil)
	 Duel.SendtoHand(tc1,nil,REASON_EFFECT)
	 Duel.ConfirmCards(1-tp,tc1)
	end
	Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end
function c33400111.thfilter(c)
	return c:IsSetCard(0x3340) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
   and not c:IsCode(33400111)
end
function c33400111.filter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400111.ss(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x3340)
end
