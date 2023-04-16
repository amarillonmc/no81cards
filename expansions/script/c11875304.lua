--封印纹章士 罗伊
function c11875304.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(function(e,c)
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	e1:SetTarget(function(e,c) 
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	e1:SetValue(function(e,c)
	return c==e:GetHandler() end)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_MOVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11875304)  
	e2:SetCondition(c11875304.spcon)
	e2:SetTarget(c11875304.sptg)  
	e2:SetOperation(c11875304.spop) 
	c:RegisterEffect(e2) 
end
c11875304.SetCard_tt_FireEmblem=true  
function c11875304.mckfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_ONFIELD)   
end 
function c11875304.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c11875304.mckfil,1,nil)  
end 
function c11875304.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_tt_FireEmblem and not c:IsCode(11875304)  
end 
function c11875304.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11875304.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end 
function c11875304.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11875304.spfil,tp,LOCATION_DECK,0,nil,e,tp)  
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11875304.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11875304.splimit(e,c)
	return not c.SetCard_tt_FireEmblem 
end











