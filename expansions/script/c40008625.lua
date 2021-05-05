--罪 二律齿轮
function c40008625.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008625,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c40008625.spcon)
	e1:SetTarget(c40008625.settg)
	e1:SetOperation(c40008625.setop)
	c:RegisterEffect(e1)  
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008625,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40008625.sccon)
	e3:SetTarget(c40008625.sctg)
	e3:SetOperation(c40008625.scop)
	c:RegisterEffect(e3)  
end
function c40008625.cfilter(c)
	return c:IsFaceup() and c:IsCode(27564031)
end
function c40008625.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(c40008625.cfilter,tp,LOCATION_FZONE,0,1,nil)
end
function c40008625.filter(c)
	return c:IsSetCard(0x23) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c40008625.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40008625.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c40008625.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c40008625.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN+EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.ConfirmCards(1-tp,g)
end
function c40008625.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c40008625.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND,0,nil,0x23)
		g1:Merge(g2)
		return not c:IsStatus(STATUS_CHAINING) and e:GetHandler():GetFlagEffect(40008625)==0
			and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c,g1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40008625.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND,0,nil,0x23)
	g1:Merge(g2)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,g1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,g1)
	end
end

