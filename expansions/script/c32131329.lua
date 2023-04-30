--逐火十三英桀的告别
function c32131329.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,32131329+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(c32131329.actg) 
	e1:SetOperation(c32131329.acop) 
	c:RegisterEffect(e1)  
end
c32131329.SetCard_HR_flame13=true  
function c32131329.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c.SetCard_HR_flame13  
end 
function c32131329.spgck(g,tp) 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and g:GetCount()>1 then return false end 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() and g:GetCount()==g:GetClassCount(Card.GetCode)  
end 
function c32131329.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c32131329.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c32131329.spgck,1,7,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end 
function c32131329.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c32131329.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)   
	if g:CheckSubGroup(c32131329.spgck,1,99,tp) then 
	local sg=g:SelectSubGroup(tp,c32131329.spgck,false,1,7,tp) 
	local tc=sg:GetFirst() 
	while tc do 
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true) 
	tc=sg:GetNext() 
	end 
	Duel.SpecialSummonComplete()
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c32131329.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c32131329.splimit(e,c)
	if c:IsType(TYPE_TOKEN) then 
	return c:GetCode()<32131200 or c:GetCode()>32131400  
	else
	return not c.SetCard_HR_flame13 
	end 
end 






