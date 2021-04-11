--马纳历亚见习教师·帕丝卡尔
function c72411160.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c72411160.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72411160)
	e1:SetCost(c72411160.cost2)
	e1:SetTarget(c72411160.target2)
	e1:SetOperation(c72411160.operation2)
	c:RegisterEffect(e1)
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72411160,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72411161)
	e3:SetCondition(c72411160.sccon)
	e3:SetTarget(c72411160.sctg)
	e3:SetOperation(c72411160.scop)
	c:RegisterEffect(e3)
end
function c72411160.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSynchroType(TYPE_NORMAL)
end
function c72411160.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x5729) and c:IsDiscardable(REASON_COST)
end
function c72411160.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411160.costfilter,tp,LOCATION_HAND,0,1,nil)  end
	Duel.DiscardHand(tp,c72411160.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c72411160.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72411161,0,0x4011,1500,1500,1,RACE_MACHINE,ATTRIBUTE_EART) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c72411160.operation2(e,tp,eg,ep,ev,re,r,rp)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,72411161,0,0x4011,1500,1500,1,RACE_MACHINE,ATTRIBUTE_EART) then return end
			local token=Duel.CreateToken(tp,72411161)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
end
function c72411160.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c72411160.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(72411160)==0
		and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:GetHandler():RegisterFlagEffect(72411160,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c72411160.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end