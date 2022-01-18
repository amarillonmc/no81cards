--超硼素巨神 杰克南瓜
function c188815.initial_effect(c)
	c:SetUniqueOnField(1,0,188815)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)   
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,188815)
	e1:SetCost(c188815.spcost1)
	e1:SetTarget(c188815.sptg1)
	e1:SetOperation(c188815.spop1)
	c:RegisterEffect(e1) 
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188815,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,088815)
	e2:SetCondition(c188815.spcon2)
	e2:SetTarget(c188815.sptg2)
	e2:SetOperation(c188815.spop2)
	c:RegisterEffect(e2)
end
function c188815.spfilter1(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGraveAsCost() and (Duel.GetMZoneCount(tp,c)>0 or c:IsLocation(LOCATION_HAND))
end
function c188815.fcheck(c,g)
	return g:IsExists(Card.IsOriginalCodeRule,1,c,c:GetOriginalCodeRule())
end
function c188815.fselect(g)
	return not g:IsExists(c188815.fcheck,1,nil,g)
end
function c188815.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c188815.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil)
	if chk==0 then return g:CheckSubGroup(c188815.fselect,2,99) end
	local sg=g:SelectSubGroup(tp,c188815.fselect,false,2,99,g)
	Duel.SendtoGrave(g,REASON_COST)
end
function c188815.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c188815.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c188815.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c188815.spfilter2(c,e,tp)
	local code=c:GetCode()
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c188815.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp,code)
end
function c188815.spfilter2(c,e,tp,code)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c188815.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c188815.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and c:IsAbleToRemove() end
	local tc=Duel.SelectTarget(tp,c188815.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c188815.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then 
	local code=tc:GetCode()
	local g=Duel.GetMatchingGroup(c188815.spfilter3,tp,LOCATION_DECK,0,nil,e,tp,code)
	if g:GetCount()<=0 then return end
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		sc:RegisterEffect(e1,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsAbleToRemove() then
			Duel.BreakEffect()
			if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetLabelObject(c)
				e2:SetCountLimit(1)
				e2:SetOperation(c188815.retop)
				Duel.RegisterEffect(e2,tp)
			end
		end 
	end
	end
end
function c188815.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end





