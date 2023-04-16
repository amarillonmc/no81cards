--失界龙 赫醒龙
function c19198211.initial_effect(c) 
	aux.AddCodeList(c,68468459)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e1:SetCountLimit(1,19198211) 
	e1:SetCost(c19198211.spcost) 
	e1:SetTarget(c19198211.sptg) 
	e1:SetOperation(c19198211.spop) 
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,29198211) 
	e2:SetCost(c19198211.thcost) 
	e2:SetTarget(c19198211.thtg) 
	e2:SetOperation(c19198211.thop) 
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_REMOVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,39198211)  
	e3:SetTarget(c19198211.rsptg) 
	e3:SetOperation(c19198211.rspop) 
	c:RegisterEffect(e3) 
	--set and to deck 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TODECK) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_PHASE+PHASE_END) 
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e4:SetRange(LOCATION_REMOVED) 
	e4:SetCountLimit(1,49198211)  
	e4:SetCondition(function(e) 
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
	e4:SetTarget(c19198211.setdtg) 
	e4:SetOperation(c19198211.setdop) 
	c:RegisterEffect(e4) 
end
function c19198211.sctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)  
end 
function c19198211.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c19198211.sctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,c19198211.sctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler()) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end 
function c19198211.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c19198211.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_CODE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(68468459) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)	
	end 
end 
function c19198211.tctfil(c) 
	return c:IsAbleToGraveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)   
end 
function c19198211.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c19198211.tctfil,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsAbleToGraveAsCost() end 
	local g=Duel.SelectMatchingCard(tp,c19198211.tctfil,tp,LOCATION_HAND,0,1,1,e:GetHandler()) 
	g:AddCard(e:GetHandler()) 
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c19198211.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x188)  
end  
function c19198211.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c19198211.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK) 
end 
function c19198211.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c19198211.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)	 
	end 
end 
function c19198211.rspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (aux.IsCodeListed(c,68468459) or c:IsCode(68468459)) 
end 
function c19198211.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c19198211.rspfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c19198211.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c19198211.rspfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 
function c19198211.setfil(c) 
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x15d) 
end 
function c19198211.setdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingTarget(c19198211.setfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c19198211.setfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
end 
function c19198211.setdop(e,tp,eg,ep,ev,re,r,rp)	 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then 
		Duel.SSet(tp,tc) 
	end  
end 







