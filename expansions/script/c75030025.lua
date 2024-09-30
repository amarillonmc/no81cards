--晓之巫女与西风盗贼
function c75030025.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c75030025.mfilter,c75030025.xyzcheck,2,2)	
	--draw and remove 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,75030025)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end) 
	e1:SetTarget(c75030025.drrtg) 
	e1:SetOperation(c75030025.drrop) 
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetCountLimit(1,15030025) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e2:SetTarget(c75030025.sptg) 
	e2:SetOperation(c75030025.spop) 
	c:RegisterEffect(e2) 
end
function c75030025.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsLevel(4)
end
function c75030025.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c75030025.drrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(function(c) return c:GetSequence()<5 and c:IsAbleToRemove() end,tp,0,LOCATION_SZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_SZONE)
end 
function c75030025.drrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(function(c) return c:GetSequence()<5 and c:IsAbleToRemove() end,tp,0,LOCATION_SZONE,1,nil) then 
		local rg=Duel.SelectMatchingCard(tp,function(c) return c:GetSequence()<5 and c:IsAbleToRemove() end,tp,0,LOCATION_SZONE,1,1,nil) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	end 
end 
function c75030025.spfil(c,e,tp) 
	return c:IsSetCard(0x754,0x753) and not c:IsCode(75030025) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function c75030025.spgck(g,e,tp) 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() and g:GetCount()==g:GetClassCount(Card.GetCode) and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
end 
function c75030025.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c75030025.spfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c75030025.spgck,2,2,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c75030025.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c75030025.spfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:CheckSubGroup(c75030025.spgck,2,2,e,tp) then 
		local sg=g:SelectSubGroup(tp,c75030025.spgck,false,2,2,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 








