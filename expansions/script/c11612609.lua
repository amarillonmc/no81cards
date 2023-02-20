--龙辉巧-扶筐四ο
local m=11612609
local cm=_G["c"..m]
function c11612609.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x154),cm.sfilter)
	c:EnableReviveLimit()   
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_GRAVE) 
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg) 
	e1:SetOperation(cm.spop) 
	c:RegisterEffect(e1)
	--e sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(function(e) 
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end)
	e2:SetCountLimit(1,11612610)   
	e2:SetTarget(cm.esptg) 
	e2:SetOperation(cm.espop) 
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(cm.synlimit)
	c:RegisterEffect(e3)
end 
--
function cm.sfilter(c)
	return not c:IsSummonableCard()
end
function cm.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
function cm.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x154) and c:IsLevel(1)   
end 
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,cm.ctfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end 
end  
function cm.etdgck(g,e,tp,rc) 
	local tc1=g:GetFirst() 
	local tc2=g:GetNext() 
	return Duel.GetLocationCountFromEx(tp,tp,g,rc)>0 and math.abs(tc1:GetLevel()-tc2:GetLevel())==rc:GetLevel() and g:IsContains(e:GetHandler()) and g:FilterCount(Card.IsType,e:GetHandler(),TYPE_RITUAL)==1   
end 
function cm.espfil(c,e,tp)  
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(cm.etdgck,2,2,e,tp,c) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function cm.esptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end 
function cm.espop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.espfil,tp,LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
		local sg=rg:SelectSubGroup(tp,cm.etdgck,false,2,2,e,tp,tc) 
		Duel.Release(sg,REASON_EFFECT) 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 


