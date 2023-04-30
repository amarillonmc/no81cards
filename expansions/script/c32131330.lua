--逐火十三英桀的过往
function c32131330.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)   
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,32131330)
	e2:SetTarget(c32131330.sptg) 
	e2:SetOperation(c32131330.spop) 
	c:RegisterEffect(e2) 
	--indes 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,23131330) 
	e3:SetTarget(c32131330.idtg) 
	e3:SetOperation(c32131330.idop)
	c:RegisterEffect(e3) 
end
c32131330.SetCard_HR_flame13=true  
function c32131330.sckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c.SetCard_HR_flame13 and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT)  
end 
function c32131330.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_HR_flame13  
end 
function c32131330.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return eg:IsExists(c32131330.sckfil,1,nil,tp) and Duel.IsExistingMatchingCard(c32131330.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c32131330.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c32131330.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end  
function c32131330.idfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13  
end 
function c32131330.idtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEUP) and Duel.IsExistingMatchingCard(c32131330.idfil,tp,LOCATION_MZONE,0,1,nil) end 
end 
function c32131330.idop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c32131330.idfil,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
	local tc=g:GetFirst() 
	while tc do 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	tc:RegisterEffect(e1)   
	tc=g:GetNext() 
	end 
	end 
end   








