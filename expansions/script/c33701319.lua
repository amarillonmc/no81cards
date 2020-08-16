--虚拟主播 本间向日葵
function c33701319.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701319,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetTarget(c33701319.sptg)
	e1:SetOperation(c33701319.spop)
	c:RegisterEffect(e1)
	--hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701319,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c33701319.hdcost)
	e2:SetOperation(c33701319.hdop)
	c:RegisterEffect(e2)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c33701319.ttcon)
	e1:SetOperation(c33701319.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33701319.cbcon)
	e2:SetValue(c33701319.xefilter1)
	c:RegisterEffect(e2)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33701319.cbcon)
	e2:SetValue(c33701319.xefilter2)
	c:RegisterEffect(e2)
end
function c33701319.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c33701319.xefilter1(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c33701319.xefilter2(e,te)
	return te:GetOwner():IsType(TYPE_MONSTER)
end
function c33701319.spfil(c,e,tp)
	return c:IsAbleToHand() and not c:IsType(TYPE_EFFECT)
end
function c33701319.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33701319.spfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.SelectMatchingCard(tp,c33701319.spfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_MZONE)
end
function c33701319.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoHand(tc,tp,REASON_EFFECT) then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
end
function c33701319.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST)
end
function c33701319.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(c33701319.eftg)
	e1:SetValue(c33701319.efilter1)  
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c33701319.eftg(e,c)
	return not c:IsType(TYPE_EFFECT)
end
function c33701319.efilter1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c33701319.ttfil(c)
	return c:IsReleasable() and not c:IsType(TYPE_EFFECT)
end
function c33701319.ttcon(e,c,minc)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c33701319.ttfil,tp,LOCATION_MZONE,0,2,nil)
end
function c33701319.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c33701319.ttfil,tp,LOCATION_MZONE,0,2,2,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c33701319.setcon(e,c,minc)
	if not c then return true end
	return false
end


