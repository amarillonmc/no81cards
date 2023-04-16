--电脑堺门-煌龙
function c19198208.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,19198208)
	e2:SetTarget(c19198208.thtg) 
	e2:SetOperation(c19198208.thop) 
	c:RegisterEffect(e2) 
	--to grave 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29198208) 
	e3:SetCost(aux.bfgcost) 
	e3:SetTarget(c19198208.tgtg) 
	e3:SetOperation(c19198208.tgop) 
	c:RegisterEffect(e3)
end 
function c19198208.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x14e) and not c:IsCode(19198208) 
end 
function c19198208.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c19198208.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1) 
end  
function c19198208.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c19198208.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) then 
			Duel.BreakEffect() 
			local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT) 
			Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)  
		end 
	end 
end 
function c19198208.tgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0x14e) and not c:IsCode(19198208) 
end 
function c19198208.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c19198208.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function c19198208.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c19198208.tgfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)  
	end 
end 






