--方舟骑士-德克萨斯
c29065521.named_with_Arknight=1
function c29065521.initial_effect(c)
	c:EnableCounterPermit(0x10ae)
	c:SetUniqueOnField(1,0,29065521,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c29065521.spcon)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c29065521.cttg)
	e2:SetOperation(c29065521.ctop)
	c:RegisterEffect(e2)
end
function c29065521.spfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065521.spcon(e,c,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c29065521.spfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c29065521.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x10ae,1) end
end
function c29065521.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then  
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	e:GetHandler():AddCounter(0x10ae,n)
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29065521,0)) then
	Duel.BreakEffect()
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)   
	end
	end
end