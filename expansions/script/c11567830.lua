--新都 中央地区
function c11567830.initial_effect(c) 
	c:EnableCounterPermit(0x37)
	c:SetCounterLimit(0x37,5)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--add 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetOperation(c11567830.adop) 
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) 
	e3:SetRange(LOCATION_FZONE)  
	e3:SetCost(c11567830.spcost) 
	e3:SetTarget(c11567830.sptg) 
	e3:SetOperation(c11567830.spop) 
	c:RegisterEffect(e3) 
	--to hand 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetRange(LOCATION_FZONE) 
	e4:SetCountLimit(1,13767830)  
	e4:SetCondition(c11567830.thcon) 
	--e4:SetCost(c11567830.thcost)
	e4:SetTarget(c11567830.thtg) 
	e4:SetOperation(c11567830.thop) 
	c:RegisterEffect(e4) 
	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0) 
	e5:SetValue(function(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0xd3) end) 
	c:RegisterEffect(e5) 
	--splimit 
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0) 
	e6:SetTarget(function(e,c)
	return not c:IsSetCard(0xd3) end)  
	c:RegisterEffect(e6) 
end
function c11567830.adop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=eg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD) 
	if x>0 then
	c:AddCounter(0x37,x,true)   
	end 
end
function c11567830.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x37,3,REASON_COST) end 
	e:GetHandler():RemoveCounter(tp,0x37,3,3,REASON_COST) 
end 
function c11567830.spfil(c,e,tp) 
	return c:IsSpecialSummonable() and c:IsSetCard(0xd3) and not c:IsPublic() 
end 
function c11567830.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c11567830.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c11567830.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
	Duel.ConfirmCards(1-tp,tc) 
	e:SetLabelObject(tc) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0) 
	Duel.SetChainLimit(aux.FALSE)
end  
function c11567830.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=e:GetLabelObject() 
	if tc and tc:IsSpecialSummonable() then 
	Duel.SpecialSummonRule(tp,tc) 
	end 
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)  
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)   
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd3)) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end 
function c11567830.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetCounter(0x37)>=3   
end 
function c11567830.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) 
end 
function c11567830.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xd3)  
end  
function c11567830.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11567830.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE) 
end 
function c11567830.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11567830.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end   
end 








