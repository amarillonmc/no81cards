--Sepialife - MONO Waltz
function c9310035.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9310035)
	e1:SetCondition(c9310035.negcon)
	e1:SetTarget(c9310035.negtg)
	e1:SetOperation(c9310035.negop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c9310035.tnval)
	c:RegisterEffect(e2)
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9311035)
	e3:SetCondition(c9310035.sccon)
	e3:SetTarget(c9310035.sctg)
	e3:SetOperation(c9310035.scop)
	c:RegisterEffect(e3)
end
function c9310035.negcon(e,tp,eg,ep,ev,re,r,rp)
	local  k=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==k and ep~=k
			and Duel.GetCurrentPhase()~=PHASE_END and Duel.IsChainNegatable(ev)
end
function c9310035.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9310035.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.NegateActivation(ev)
		Duel.BreakEffect()
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
function c9310035.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310035.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c9310035.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9310035.cfilter(c,g,mc)
	return g:CheckSubGroup(c9310035.mtfilter,1,#g,mc,c)
end
function c9310035.mtfilter(g,mc,c)
	local sg=g:Clone()
	sg:AddCard(mc)
	return sg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel() and c:IsSynchroSummonable(nil,sg)
end
function c9310035.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local sg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,0,kc)
	local kg=Duel.GetMatchingGroup(c9310035.cfilter,tp,LOCATION_EXTRA,0,nil,sg,kc)
	if kg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local kg2=kg:Select(tp,1,1,nil)
		local sc=kg2:GetFirst()
		local sg1=sg:SelectSubGroup(tp,c9310035.mtfilter,false,1,#sg,kc,sc)
		sg1:Merge(kc)
		sc:SetMaterial(sg1)
		Duel.BreakEffect()
		Duel.SynchroSummon(tp,sc,nil,sg1)
		sc:CompleteProcedure()
	end
end