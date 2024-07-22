--天垣修正者 百解
function c67200939.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:SetSPSummonOnce(67200939)
	--apply
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200939,0))
	e0:SetCategory(CATEGORY_TOEXTRA)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCondition(c67200939.opcon)
	e0:SetTarget(c67200939.optg)
	e0:SetOperation(c67200939.opop)
	c:RegisterEffect(e0)
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200939,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67200939.pspcon)
	e1:SetTarget(c67200939.pstg)
	e1:SetOperation(c67200939.psop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c67200939.cost)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200939.stcon)
	e2:SetTarget(c67200939.sptg)
	e2:SetOperation(c67200939.spop)
	c:RegisterEffect(e2)	
end
function c67200939.cfilter1(c)
	return c:IsFaceup() 
end
function c67200939.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200939.cfilter1,1,nil)
end
function c67200939.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c67200939.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
	end
end
--
function c67200939.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and bit.band(loc,LOCATION_PZONE)==LOCATION_PZONE and rc:IsSetCard(0x67a) and not rc:IsCode(67200939))
end
function c67200939.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200939.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)))
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(67200939,3)},{b2,1152})
		if op==1 then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		if op==2 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c67200939.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a) and Duel.GetMZoneCount(tp,c)>0 
end
function c67200939.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200939.cfilter,tp,LOCATION_ONFIELD,0,1,c,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200939.cfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c67200939.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,67200939)==0 and Duel.GetTurnPlayer()==1-tp
end
function c67200939.sfilter(c,e,tp)
	return c:IsSetCard(0x67a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and  c:IsAttribute(ATTRIBUTE_WIND)
end
function c67200939.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:IsCostChecked() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		and Duel.IsExistingMatchingCard(c67200939.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.RegisterFlagEffect(tp,67200939,RESET_PHASE+PHASE_END,0,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c67200939.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200939.sfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--