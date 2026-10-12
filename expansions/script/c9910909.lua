--命定的神械死囚
function c9910909.initial_effect(c)
	aux.AddCodeList(c,9910871)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--destroy pzone
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910909)
	e1:SetTarget(c9910909.sptg)
	e1:SetOperation(c9910909.spop)
	c:RegisterEffect(e1)
	--destroy mzone
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c9910909.destg)
	e2:SetOperation(c9910909.desop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetTarget(c9910909.thtg)
	e3:SetOperation(c9910909.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c9910909.thcon)
	c:RegisterEffect(e4)
end
function c9910909.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c9910909.spfilter(c,e,tp)
	return (aux.IsCodeListed(c,9910871) or c:IsSetCard(0xc954))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9910909.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910909.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local off=1
	local ops={}
	local opval={}
	if #g>0 then
		ops[off]=aux.Stringid(9910909,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetFlagEffect(tp,9910909)==0 then
		ops[off]=aux.Stringid(9910909,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(9910909,2)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	elseif opval[op]==2 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(0,LOCATION_ONFIELD)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,9910909,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910909.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c9910909.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if c:IsRelateToChain() then g:AddCard(c) end
	Duel.Destroy(g,REASON_EFFECT)
end
function c9910909.thcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c9910909.thfilter(c)
	return (aux.IsCodeListed(c,9910871) or c:IsSetCard(0xc954)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910909.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910909.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910909.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910909.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
