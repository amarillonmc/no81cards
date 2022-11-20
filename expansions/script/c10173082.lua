--暗黑剑士 维吉尔
function c10173082.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetCondition(c10173082.rmcon)
	c:RegisterEffect(e1) 
	--sp1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173082,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCost(c10173082.spcost)
	e2:SetTarget(c10173082.sptg)
	e2:SetOperation(c10173082.spop)
	c:RegisterEffect(e2)  
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c10173082.spcon2)
	e3:SetOperation(c10173082.spop2)
	c:RegisterEffect(e3) 
end
function c10173082.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10173082.cfilter2,tp,LOCATION_HAND,0,1,c)
end
function c10173082.cfilter2(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c10173082.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10173082,1))
	local g=Duel.SelectMatchingCard(tp,c10173082.cfilter2,tp,LOCATION_HAND,0,1,1,c)
	if g:GetCount()>0 then
	   Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
function c10173082.cfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup() and Duel.GetMZoneCount(tp,c,tp)>0
end
function c10173082.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173082.cfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10173082,1))
	local g=Duel.SelectMatchingCard(tp,c10173082.cfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,e:GetHandler(),tp)
	if g:GetCount()>0 then
	   Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
function c10173082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10173082.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10173082.rmcon(e)
	local c=e:GetHandler()
	return c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
