--温暖的韶光 妃玲奈
function c9910460.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910460)
	e1:SetCondition(c9910460.spcon)
	e1:SetCost(c9910460.spcost)
	e1:SetTarget(c9910460.sptg)
	e1:SetOperation(c9910460.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetTarget(c9910460.rctg)
	e2:SetOperation(c9910460.rcop)
	c:RegisterEffect(e2)
end
function c9910460.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910460.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1950,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1950,2,REASON_COST)
end
function c9910460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910460.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9950)
end
function c9910460.ctfilter(c)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return c:IsCanAddCounter(0x1950,1) and g:IsExists(c9910460.cfilter,1,nil)
end
function c9910460.disfilter(c)
	return c:GetCounter(0x1950)>0 and aux.NegateMonsterFilter(c)
end
function c9910460.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g1=Duel.GetMatchingGroup(c9910460.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c9910460.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local off=1
	local ops={}
	local opval={}
	if g1:GetCount()>0 then
		ops[off]=aux.Stringid(9910460,0)
		opval[off-1]=1
		off=off+1
	end
	if g2:GetCount()>0 then
		ops[off]=aux.Stringid(9910460,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(9910460,2)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		local sc=g1:GetFirst()
		while sc do
			sc:AddCounter(0x1950,1)
			sc=g1:GetNext()
		end
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sg=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c9910460.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c9910460.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==tp and Duel.IsPlayerAffectedByEffect(tp,9910467) then d=2*d end
	Duel.Recover(p,d,REASON_EFFECT)
end
