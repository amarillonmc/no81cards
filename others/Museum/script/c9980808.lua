--将军与21枚硬币
function c9980808.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9980808.target1)
	e1:SetOperation(c9980808.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980808,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c9980808.condition)
	e2:SetTarget(c9980808.target2)
	e2:SetOperation(c9980808.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980808,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c9980808.spcon)
	e3:SetCost(c9980808.spcost)
	e3:SetTarget(c9980808.sptg)
	e3:SetOperation(c9980808.spop)
	c:RegisterEffect(e3)
end
function c9980808.filter1(c)
	return c:IsFaceup() and c:IsCode(9980777)
end
function c9980808.filter2(c)
	return c:IsSetCard(0xabc1) and c:IsType(TYPE_FUSION) and c:IsAbleToRemove()
end
function c9980808.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980808.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c9980808.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980808,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c9980808.sdescon)
	e1:SetOperation(c9980808.sdesop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,5)
	c:RegisterEffect(e1)
	c:SetTurnCounter(0)
	if Duel.IsExistingMatchingCard(c9980808.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c9980808.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9980808,0)) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
		c:RegisterFlagEffect(9980808,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		c:RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9980808,1))
	end
end
function c9980808.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetFlagEffect(9980808)==0
		and Duel.IsExistingMatchingCard(c9980808.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	e:GetHandler():RegisterFlagEffect(9980808,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9980808.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(9980808)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9980808.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c9980808.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c9980808.sdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.Destroy(c,REASON_RULE)
	end
end
function c9980808.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980808.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xabc1) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9980808.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9980808.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c9980808.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9980808.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c9980808.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local dg=Duel.GetMatchingGroup(c9980808.desfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
