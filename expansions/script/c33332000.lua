--苍星之狂智 埃德尔
function c33332000.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,c33332000.mfilter,9,2)
	c:EnableReviveLimit() 
	--sp
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetCost(c33332000.spcost)
	e1:SetTarget(c33332000.sptg) 
	e1:SetOperation(c33332000.spop) 
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON) 
	e2:SetCondition(c33332000.disspcon)
	e2:SetTarget(c33332000.dissptg)
	e2:SetOperation(c33332000.disspop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE) 
	e3:SetTarget(c33332000.psptg) 
	e3:SetOperation(c33332000.pspop) 
	c:RegisterEffect(e3) 
end
function c33332000.mfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_WATER)
end 
function c33332000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33332000.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_WATER) 
end 
function c33332000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332000.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c33332000.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332000.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 
function c33332000.disspcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end 
function c33332000.dissptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0) 
end
function c33332000.disspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then 
		Duel.NegateSummon(eg)
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT) 
	end 
end  
function c33332000.sctfil(c) 
	return c:IsCanOverlay() and c:IsRace(RACE_PSYCHO) and c:IsLevelAbove(1) 
end  
function c33332000.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33332000.sctfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:CheckWithSumGreater(Card.GetLevel,9) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33332000.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332000.sctfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:CheckWithSumGreater(Card.GetLevel,9) then 
		local sg=g:SelectWithSumGreater(tp,Card.GetLevel,9)
		Duel.Overlay(c,sg) 
	end 
end 








