--饥献仪式者 献祭之格拉斯
function c19209935.initial_effect(c)
	c:EnableCounterPermit(0xb55)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209935,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,19209935)
	e1:SetCost(c19209935.spscost)
	e1:SetTarget(c19209935.spstg)
	e1:SetOperation(c19209935.spsop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c19209935.ctop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19209935,1))
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(c19209935.rlcon)
	e3:SetTarget(c19209935.rltg)
	e3:SetOperation(c19209935.rlop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e4:SetDescription(aux.Stringid(19209935,2))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	--e4:SetCountLimit(1,19209935)
	e4:SetCondition(c19209935.spcon)
	e4:SetCost(c19209935.spcost)
	e4:SetTarget(c19209935.sptg)
	e4:SetOperation(c19209935.spop)
	c:RegisterEffect(e4)
end
function c19209935.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c19209935.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c19209935.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c19209935.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c19209935.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209935.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209935.ctfilter(c,tp)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c19209935.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c19209935.ctfilter,nil,tp)
	if ct>0 then
		e:GetHandler():AddCounter(0xb55,ct)
	end
end
function c19209935.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(Card.IsControler,1,nil,1-tp) and not eg:IsContains(e:GetHandler())
end
function c19209935.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:IsExists(Card.IsReleasable,1,nil,REASON_RULE) and Duel.IsPlayerCanRelease(1-tp) end
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,tg,1,0,0)
end
function c19209935.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		local tc=tg:GetFirst()
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg=tg:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		end
		Duel.Release(tc,REASON_RULE,1-tp)
	end
end
function c19209935.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2--Duel.IsMainPhase()
end
function c19209935.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xb55,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xb55,4,REASON_COST)
end
function c19209935.spfilter(c,e,tp)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c19209935.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c19209935.spfilter,tp,LOCATION_HAND+LOCATION_DECK+0x10,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+0x10)
end
function c19209935.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.Release(c,REASON_EFFECT)==0 or Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c19209935.spfilter,tp,LOCATION_HAND+LOCATION_DECK+0x10,0,1,1,nil,e,tp):GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
