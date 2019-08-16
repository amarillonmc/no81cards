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
   local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 and  Duel.SelectYesNo(tp,aux.Stringid(33400111,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	local dg2=Duel.GetMatchingGroup(c33400111.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
	   if Duel.GetMatchingGroupCount(c33400111.ss,tp,LOCATION_GRAVE,0,nil)>=3 and  dg2:GetCount()>0  and Duel.SelectYesNo(tp,aux.Stringid(33400111,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=dg2:Select(tp,1,1,nil)
			Duel.HintSelection(sg2)
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	  end
end
function c33400111.filter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400111.ss(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x3340)
end
