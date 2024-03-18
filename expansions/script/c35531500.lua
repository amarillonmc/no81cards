--灰流丽·惊奇
function c35531500.initial_effect(c)
	aux.AddCodeList(c,14558127)
	--sp
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_GRAVE) 
	e1:SetCountLimit(1,35531500)
	e1:SetTarget(c35531500.sptg) 
	e1:SetOperation(c35531500.spop) 
	c:RegisterEffect(e1) 
end
function c35531500.ctfil(c,e,tp) 
	return (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c35531500.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end 
function c35531500.espfil(c,e,tp,lv) 
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLevel(lv+e:GetHandler():GetLevel()) 
end 
function c35531500.espfil2(c,e,tp,lv1,lv2) 
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLevel(lv1+lv2+e:GetHandler():GetLevel()) 
end 
function c35531500.pbfil(c,e,tp,lv) 
	return not c:IsPublic() and c:IsLevelAbove(1) and (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and Duel.IsExistingMatchingCard(c35531500.espfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,c:GetLevel())
end 
function c35531500.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c35531500.ctfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c35531500.ctfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp):GetFirst() 
	local lv=tc:GetLevel() 
	local g=Group.FromCards(tc,e:GetHandler()) 
	if Duel.IsExistingMatchingCard(c35531500.pbfil,tp,LOCATION_HAND,0,1,nil,e,tp,lv) and Duel.SelectYesNo(tp,aux.Stringid(35531500,0)) then 
		local pc=Duel.SelectMatchingCard(tp,c35531500.pbfil,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv):GetFirst()  
		Duel.ConfirmCards(1-tp,pc) 
		Duel.ShuffleHand(tp)
		lv=lv+pc:GetLevel() 
	end  
	e:SetLabel(lv)
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c35531500.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local lv=e:GetLabel()
	if lv and Duel.IsExistingMatchingCard(c35531500.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) then 
		local sc=Duel.SelectMatchingCard(tp,c35531500.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst() 
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure() 
	end 
end 




