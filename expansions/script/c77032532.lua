--银河眼狩猎
function c77032532.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c77032532.sptg) 
	e2:SetOperation(c77032532.spop) 
	c:RegisterEffect(e2) 
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(function(e,c) 
	return c:IsSetCard(0x107b) end)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3) 
	--sp 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_LEAVE_FIELD) 
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,77032532)  
	e4:SetCondition(c77032532.xspcon) 
	e4:SetTarget(c77032532.xsptg) 
	e4:SetOperation(c77032532.xspop) 
	c:RegisterEffect(e4) 
end
function c77032532.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(93717133)  
end 
function c77032532.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77032532.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end 
function c77032532.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77032532.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 
function c77032532.sckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:IsSetCard(0x107b) and c:IsReason(REASON_EFFECT)  
end 
function c77032532.xspcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c77032532.sckfil,1,nil,tp) 
end 
function c77032532.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()  
end 
function c77032532.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77032532.xspfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_REMOVED) 
end 
function c77032532.xspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77032532.xspfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 












