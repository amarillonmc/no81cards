--黄昏图腾
function c9910623.initial_effect(c)
	aux.AddCodeList(c,9910316,9910624)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910623+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910623.spcon)
	e1:SetValue(c9910623.spval)
	e1:SetOperation(c9910623.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9910623.thcon)
	e2:SetOperation(c9910623.thop)
	c:RegisterEffect(e2)
	--switch locations
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,9910622)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCondition(c9910623.chcon)
	e3:SetCost(c9910623.chcost)
	e3:SetTarget(c9910623.chtg)
	e3:SetOperation(c9910623.chop)
	c:RegisterEffect(e3)
end
function c9910623.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c9910623.spval(e,c)
	return SUMMON_VALUE_SELF,Duel.GetLinkedZone(c:GetControler())
end
function c9910623.lfilter(c,mc)
	return c:IsCode(9910316,9910624) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(mc)
end
function c9910623.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
		and Duel.IsExistingMatchingCard(c9910623.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function c9910623.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)
end
function c9910623.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910623.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c9910623.chfilter(c)
	return c:GetSequence()<5
end
function c9910623.gcheck(g)
	return g:GetClassCount(Card.GetControler)==1
end
function c9910623.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910623.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:CheckSubGroup(c9910623.gcheck,2,2) end
end
function c9910623.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910623.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c9910623.gcheck,false,2,2)
	if sg then
		Duel.HintSelection(sg)
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SwapSequence(tc1,tc2)
	end
end
